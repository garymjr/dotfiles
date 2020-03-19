/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { CancellationToken, CompletionContext, CompletionItem, Position, TextDocument } from 'vscode-languageserver-protocol'
import { CompletionItemProvider } from 'coc.nvim/lib/provider'
import * as Proto from '../protocol'
import { ITypeScriptServiceClient } from '../typescriptService'
import * as typeConverters from '../utils/typeConverters'

export default class TypeScriptTagCompletion implements CompletionItemProvider {
  constructor(
    private readonly client: ITypeScriptServiceClient
  ) { }

  public async provideCompletionItems(
    document: TextDocument,
    position: Position,
    token: CancellationToken,
    context: CompletionContext
  ): Promise<CompletionItem[] | undefined> {
    const filepath = this.client.toPath(document.uri)
    if (!filepath) return undefined
    if (context.triggerCharacter != '>') {
      return undefined
    }

    const args: Proto.JsxClosingTagRequestArgs = typeConverters.Position.toFileLocationRequestArgs(filepath, position)
    let body: Proto.TextInsertion | undefined
    try {
      const response = await this.client.execute('jsxClosingTag', args, token)
      body = response && (response as any).body
      if (!body) {
        return undefined
      }
    } catch {
      return undefined
    }

    return [this.getCompletion(body)]
  }

  private getCompletion(body: Proto.TextInsertion): CompletionItem {
    const completion = CompletionItem.create(body.newText)
    completion.insertText = this.getTagSnippet(body) // tslint:disable-line
    return completion
  }

  private getTagSnippet(closingTag: Proto.TextInsertion): string {
    let { newText, caretOffset } = closingTag
    return newText.slice(0, caretOffset) + '$0' + newText.slice(caretOffset)
  }
}
