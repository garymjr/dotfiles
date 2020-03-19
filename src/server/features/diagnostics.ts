/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { Diagnostic } from 'vscode-languageserver-protocol'
import { workspace, languages, DiagnosticCollection } from 'coc.nvim'
import { ResourceMap } from './resourceMap'

export class DiagnosticSet {
  private _map = new ResourceMap<Diagnostic[]>()

  public set(uri: string, diagnostics: Diagnostic[]): void {
    this._map.set(uri, diagnostics)
  }

  public get(uri: string): Diagnostic[] {
    return this._map.get(uri) || []
  }

  public clear(): void {
    this._map = new ResourceMap<Diagnostic[]>()
  }
}

export enum DiagnosticKind {
  Syntax,
  Semantic,
  Suggestion
}

const allDiagnosticKinds = [
  DiagnosticKind.Syntax,
  DiagnosticKind.Semantic,
  DiagnosticKind.Suggestion
]

export class DiagnosticsManager {
  private readonly _diagnostics = new Map<DiagnosticKind, DiagnosticSet>()
  private readonly _currentDiagnostics: DiagnosticCollection
  private _pendingUpdates = new ResourceMap<any>()
  private _enableJavascriptSuggestions = true
  private _enableTypescriptSuggestions = true

  private readonly updateDelay = 200

  constructor() {
    for (const kind of allDiagnosticKinds) {
      this._diagnostics.set(kind, new DiagnosticSet())
    }
    this._currentDiagnostics = languages.createDiagnosticCollection('tsserver')
  }

  public dispose(): void {
    this._currentDiagnostics.dispose()
    for (const value of this._pendingUpdates.values) {
      clearTimeout(value)
    }
    this._pendingUpdates = new ResourceMap<any>()
  }

  public reInitialize(): void {
    this._currentDiagnostics.clear()
    for (const diagnosticSet of this._diagnostics.values()) {
      diagnosticSet.clear()
    }
  }

  public setEnableSuggestions(languageId: string, value: boolean): void {
    let curr = languageId == 'javascript' ? this._enableJavascriptSuggestions : this._enableTypescriptSuggestions
    if (curr == value) {
      return
    }
    if (languageId == 'javascript') {
      this._enableJavascriptSuggestions = value
    } else {
      this._enableTypescriptSuggestions = value
    }
  }

  public diagnosticsReceived(
    kind: DiagnosticKind,
    uri: string,
    diagnostics: Diagnostic[]
  ): void {
    const collection = this._diagnostics.get(kind)
    if (!collection) return

    if (diagnostics.length === 0) {
      const existing = collection.get(uri)
      if (existing.length === 0) {
        // No need to update
        return
      }
    }

    collection.set(uri, diagnostics)

    this.scheduleDiagnosticsUpdate(uri)
  }

  public configFileDiagnosticsReceived(
    uri: string,
    diagnostics: Diagnostic[]
  ): void {
    this._currentDiagnostics.set(uri, diagnostics)
  }

  public delete(uri: string): void {
    this._currentDiagnostics.delete(uri)
  }

  public getDiagnostics(uri: string): Diagnostic[] {
    return this._currentDiagnostics.get(uri) || []
    return []
  }

  private scheduleDiagnosticsUpdate(uri: string): void {
    if (!this._pendingUpdates.has(uri)) {
      this._pendingUpdates.set(
        uri,
        setTimeout(() => this.updateCurrentDiagnostics(uri), this.updateDelay)
      )
    }
  }

  private updateCurrentDiagnostics(uri: string): void {
    if (this._pendingUpdates.has(uri)) {
      clearTimeout(this._pendingUpdates.get(uri))
      this._pendingUpdates.delete(uri)
    }

    const allDiagnostics = [
      ...this._diagnostics.get(DiagnosticKind.Syntax)!.get(uri),
      ...this._diagnostics.get(DiagnosticKind.Semantic)!.get(uri),
      ...this.getSuggestionDiagnostics(uri)
    ]
    this._currentDiagnostics.set(uri, allDiagnostics)
  }

  private getSuggestionDiagnostics(uri: string): Diagnostic[] {
    const enabled = this.suggestionsEnabled(uri)
    return this._diagnostics
      .get(DiagnosticKind.Suggestion)!
      .get(uri)
      .filter(x => {
        if (!enabled) {
          // Still show unused
          return x.code == 6133
        }
        return enabled
      })
  }

  private suggestionsEnabled(uri: string): boolean {
    let doc = workspace.getDocument(uri)
    if (!doc) return false
    if (doc.filetype.startsWith('javascript')) {
      return this._enableJavascriptSuggestions
    }
    if (doc.filetype.startsWith('typescript')) {
      return this._enableTypescriptSuggestions
    }
    return true
  }
}
