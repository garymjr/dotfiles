/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { commands, workspace } from 'coc.nvim'
import { Command } from 'coc.nvim/lib/commands'
import { CodeActionProvider } from 'coc.nvim/lib/provider'
import { CancellationToken, CodeAction, CodeActionContext, CodeActionKind, Diagnostic, Range, TextDocument } from 'vscode-languageserver-protocol'
import * as Proto from '../protocol'
import { ITypeScriptServiceClient } from '../typescriptService'
import API from '../utils/api'
import { applyCodeActionCommands, getEditForCodeAction } from '../utils/codeAction'
import * as typeConverters from '../utils/typeConverters'
import BufferSyncSupport from './bufferSyncSupport'
import { DiagnosticsManager } from './diagnostics'

class ApplyCodeActionCommand implements Command {
  public static readonly ID = '_typescript.applyCodeActionCommand'
  public readonly id = ApplyCodeActionCommand.ID

  constructor(
    private readonly client: ITypeScriptServiceClient,
  ) { }

  public async execute(action: Proto.CodeFixAction): Promise<boolean> {
    return applyCodeActionCommands(this.client, action)
  }
}

class ApplyFixAllCodeAction implements Command {
  public static readonly ID = '_typescript.applyFixAllCodeAction'
  public readonly id = ApplyFixAllCodeAction.ID

  constructor(
    private readonly client: ITypeScriptServiceClient,
  ) { }

  public async execute(
    file: string,
    tsAction: Proto.CodeFixAction
  ): Promise<void> {
    if (!tsAction.fixId) {
      return
    }

    const args: Proto.GetCombinedCodeFixRequestArgs = {
      scope: {
        type: 'file',
        args: { file }
      },
      fixId: tsAction.fixId
    }

    try {
      const res = await this.client.execute('getCombinedCodeFix', args, CancellationToken.None)
      if (res.type != 'response') {
        return
      }
      let { body } = res

      const edit = typeConverters.WorkspaceEdit.fromFileCodeEdits(
        this.client,
        body.changes
      )
      await workspace.applyEdit(edit)
      const token = CancellationToken.None

      const { commands } = body
      if (commands && commands.length) {
        for (const command of commands) {
          await this.client.execute('applyCodeActionCommand', { command }, token)
        }
      }
    } catch {
      // noop
    }
  }
}

/**
 * Unique set of diagnostics keyed on diagnostic range and error code.
 */
class DiagnosticsSet {
  public static from(diagnostics: Diagnostic[]): DiagnosticsSet {
    const values = new Map<string, Diagnostic>()
    for (const diagnostic of diagnostics) {
      values.set(DiagnosticsSet.key(diagnostic), diagnostic)
    }
    return new DiagnosticsSet(values)
  }

  private static key(diagnostic: Diagnostic): string {
    const { start, end } = diagnostic.range
    return `${diagnostic.code}-${start.line},${start.character}-${end.line},${end.character}`
  }

  private constructor(
    private readonly _values: Map<string, Diagnostic>
  ) { }

  public get values(): Iterable<Diagnostic> {
    return this._values.values()
  }
}

class SupportedCodeActionProvider {
  private _supportedCodeActions?: Thenable<Set<number>>

  public constructor(private readonly client: ITypeScriptServiceClient) { }

  public async getFixableDiagnosticsForContext(
    context: CodeActionContext
  ): Promise<Diagnostic[]> {
    const supportedActions = await this.supportedCodeActions
    const fixableDiagnostics = DiagnosticsSet.from(
      context.diagnostics.filter(diagnostic =>
        supportedActions.has(+diagnostic.code!)
      )
    )
    return Array.from(fixableDiagnostics.values)
  }

  private get supportedCodeActions(): Promise<Set<number>> {
    if (!this._supportedCodeActions) {
      return new Promise<Set<number>>((resolve, reject) => {
        this.client.execute('getSupportedCodeFixes', null, CancellationToken.None).then(res => {
          if (res.type !== 'response') {
            resolve(new Set())
            return
          }
          let codes = res.body.map(code => +code).filter(code => !isNaN(code))
          resolve(new Set(codes))
        }, reject)
      })
    }
    return Promise.resolve(this._supportedCodeActions)
  }
}

export default class TypeScriptQuickFixProvider implements CodeActionProvider {
  private readonly supportedCodeActionProvider: SupportedCodeActionProvider

  constructor(
    private readonly client: ITypeScriptServiceClient,
  ) {
    commands.register(
      new ApplyCodeActionCommand(client)
    )
    commands.register(
      new ApplyFixAllCodeAction(client)
    )

    this.supportedCodeActionProvider = new SupportedCodeActionProvider(client)
  }

  public async provideCodeActions(
    document: TextDocument,
    _range: Range,
    context: CodeActionContext,
    token: CancellationToken
  ): Promise<CodeAction[]> {
    if (!this.client.apiVersion.gte(API.v213)) {
      return []
    }

    const file = this.client.toPath(document.uri)
    if (!file) {
      return []
    }

    const fixableDiagnostics = await this.supportedCodeActionProvider.getFixableDiagnosticsForContext(
      context
    )
    if (!fixableDiagnostics.length) {
      return []
    }

    if (this.client.bufferSyncSupport.hasPendingDiagnostics(document.uri)) {
      return []
    }

    const results: CodeAction[] = []
    for (const diagnostic of fixableDiagnostics) {
      results.push(
        ...(await this.getFixesForDiagnostic(document, file, diagnostic, token))
      )
    }
    return results
  }

  private async getFixesForDiagnostic(
    document: TextDocument,
    file: string,
    diagnostic: Diagnostic,
    token: CancellationToken
  ): Promise<Iterable<CodeAction>> {
    const args: Proto.CodeFixRequestArgs = {
      ...typeConverters.Range.toFileRangeRequestArgs(file, diagnostic.range),
      errorCodes: [+diagnostic.code!]
    }
    const codeFixesResponse = await this.client.execute(
      'getCodeFixes',
      args,
      token
    )
    if (codeFixesResponse.type != 'response') {
      return []
    }
    if (codeFixesResponse.body) {
      const results: CodeAction[] = []
      for (const tsCodeFix of codeFixesResponse.body) {
        results.push(
          ...(await this.getAllFixesForTsCodeAction(
            document,
            file,
            diagnostic,
            tsCodeFix
          ))
        )
      }
      return results
    }
    return []
  }

  private async getAllFixesForTsCodeAction(
    document: TextDocument,
    file: string,
    diagnostic: Diagnostic,
    tsAction: Proto.CodeAction
  ): Promise<Iterable<CodeAction>> {
    const singleFix = this.getSingleFixForTsCodeAction(diagnostic, tsAction)
    const fixAll = await this.getFixAllForTsCodeAction(
      document,
      file,
      diagnostic,
      tsAction as Proto.CodeFixAction
    )
    return fixAll ? [singleFix, fixAll] : [singleFix]
  }

  private getSingleFixForTsCodeAction(
    diagnostic: Diagnostic,
    tsAction: Proto.CodeAction
  ): CodeAction {
    const codeAction: CodeAction = {
      title: tsAction.description,
      kind: CodeActionKind.QuickFix
    }
    codeAction.edit = getEditForCodeAction(this.client, tsAction)
    codeAction.diagnostics = [diagnostic]
      ; (codeAction as any).isPrefered = true
    if (tsAction.commands) {
      codeAction.command = {
        command: ApplyCodeActionCommand.ID,
        arguments: [tsAction],
        title: tsAction.description
      }
    }
    return codeAction
  }

  private async getFixAllForTsCodeAction(
    document: TextDocument,
    file: string,
    diagnostic: Diagnostic,
    tsAction: Proto.CodeFixAction
  ): Promise<CodeAction | undefined> {
    if (!tsAction.fixId || !this.client.apiVersion.gte(API.v270)) {
      return undefined
    }

    // Make sure there are multiple diagnostics of the same type in the file
    if (!this.client.diagnosticsManager
      .getDiagnostics(document.uri)
      .some(x => x.code === diagnostic.code && x !== diagnostic)) {
      return
    }

    const action: CodeAction = {
      title: tsAction.fixAllDescription || 'Fix all in file',
      kind: CodeActionKind.QuickFix
    }
    action.diagnostics = [diagnostic]
    action.command = {
      command: ApplyFixAllCodeAction.ID,
      arguments: [file, tsAction],
      title: ''
    }
    return action
  }
}
