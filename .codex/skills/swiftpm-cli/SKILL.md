---
name: swiftpm-cli
description: Use for Swift Package Manager CLI work in Codex, including swift build, swift test, Package.swift inspection, SwiftPM scratch paths, macOS package builds, and avoiding known sandbox-exec sandbox_apply failures before running SwiftPM commands.
---

# SwiftPM CLI

## Overview

Run SwiftPM through the repo's intended wrapper or with explicit local scratch settings so Codex gets a real build/test signal instead of a macOS sandbox failure.

## Command Selection

1. Inspect `Package.swift`, `mise.toml`, `.mise.toml`, `.tool-versions`, `Makefile`, `justfile`, and `script/` or `scripts/` build wrappers before choosing a command.
2. Prefer the repo's wrapper when it already uses `swift build --disable-sandbox --scratch-path ...`, signs an app bundle, or verifies packaging.
3. Prefer `mise exec -- swift ...` when the repo uses mise for Swift versions or tasks.
4. Run the smallest useful target first, then broaden only after the focused build/test passes.

## Sandbox-Safe Defaults

For direct SwiftPM validation in Codex on macOS, prefer explicit SwiftPM options from the start:

```bash
mise exec -- swift build --disable-sandbox --scratch-path /private/tmp/<repo>-swiftpm
mise exec -- swift test --disable-sandbox --scratch-path /private/tmp/<repo>-swiftpm
```

Use a repo/task-specific scratch directory under `/private/tmp`. Remove only the scratch directory you created before finishing.

If the repo's build script already chooses a scratch path, do not override it unless it fails.

## Failure Interpretation

If SwiftPM still fails before compiling source with:

```text
sandbox-exec: sandbox_apply: Operation not permitted
```

Treat that as an environment/sandbox issue, not a source regression. Retry the same narrow command with sandbox escalation if the command is project-local and otherwise safe. Do not report it as a failing build until a non-sandboxed SwiftPM run reaches real compiler or test output.

## Reporting

Mention the exact SwiftPM command, whether a wrapper was used, the scratch path, and whether cleanup was performed.
