---
name: go-cli
description: Use for Go CLI work in Codex, including go test, go build, go vet, gofmt, module commands, Go caches, and avoiding known sandbox failures from default Go build cache paths before running commands.
---

# Go CLI

## Overview

Run Go commands with explicit writable caches so Codex avoids default cache paths that may be blocked by the sandbox.

## Sandbox-Safe Defaults

Before running `go test`, `go build`, `go vet`, or Go-based generators in Codex, set a repo-specific cache under `/private/tmp`:

```bash
GOCACHE=/private/tmp/<repo>-go-cache mise exec -- go test ./...
GOCACHE=/private/tmp/<repo>-go-cache mise exec -- go build ./...
```

Use `mise exec --` when the repo defines Go through mise. If not, use the same `GOCACHE=... go ...` pattern directly.

For module downloads, keep the normal project behavior unless the sandbox blocks a cache path. Do not set `GOMODCACHE` unless needed; if needed, use a repo-specific `/private/tmp/<repo>-gomodcache` path and clean it up when finished.

## Command Selection

1. Inspect `go.mod`, `go.work`, `mise.toml`, `.tool-versions`, and repo docs before choosing commands.
2. Run focused package tests first, then `./...` when the focused checks pass or the change is shared.
3. Use the repo's existing package manager or task wrapper when it already sets Go versions or environment.
4. Avoid broad environment dumps; inspect only exact variables when needed.

## Failure Interpretation

If a Go command fails with `operation not permitted` under `~/Library/Caches/go-build` or another default cache location, rerun with explicit `GOCACHE` before diagnosing source code. If it fails after using the writable cache, treat the resulting compiler/test output normally.

## Cleanup

Remove only the `/private/tmp/<repo>-go-cache` or `/private/tmp/<repo>-gomodcache` directories you created. Report cleanup in the final summary when the cache was created for the task.
