---
description: Create AGENTS.md by analyzing project structure
---

Analyze this codebase and create an AGENTS.md file in the current directory containing:

1. Build/lint/test commands - especially for running a single test
   - Check package.json scripts
   - Look for Makefile or other build systems
   - Identify test runners (jest, vitest, pytest, etc.)
   - Include commands for running specific tests

2. Code style guidelines including:
   - Import statements and module system (ESM vs CommonJS, file extensions)
   - Formatting conventions (indentation, quotes, semicolons)
   - Type usage (TypeScript strict mode, any types, type annotations)
   - Naming conventions (files, classes, functions, variables, constants)
   - Error handling patterns (try/catch, custom errors, error propagation)
   - Testing conventions

3. Any existing rules:
   - Cursor rules from .cursor/rules/ or .cursorrules
   - Copilot instructions from .github/copilot-instructions.md

4. Architecture overview:
   - Project structure and key directories
   - Main entry points and abstractions
   - Important patterns or conventions

5. Other helpful information:
   - Dependencies and external libraries used
   - Development workflow
   - Extension points or customization options

The file should be well-structured with markdown headings and code examples. If an AGENTS.md already exists, review it and improve/expand it with any missing information.
