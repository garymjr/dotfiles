---
name: nushell-custom-completions
description: Build and maintain custom completions for Nushell commands and externs. Use when the user asks to add or update tab completion behavior, dynamic argument or flag suggestions, context-aware completion, completion descriptions/styles, or completion options in `.nu` files (for example `config.nu`, modules, and command wrappers).
---

# Nushell Custom Completions

## Workflow

1. Identify the target command, argument, and completion behavior.
2. Choose the completion source pattern: static list, dynamic command output, structured records, or context-aware logic.
3. Implement a completer function with `def` (often named `nu-complete ...`).
4. Attach the completer with `<shape>@<completer>` on `def` or `extern` parameters and flags.
5. Reparse or re-source the updated module/file, then verify tab-completion behavior interactively.

## Core Rules

- Return one of these from a completer:
  - `list<string>`
  - `list<record>` with `value` and optional `description` and `style`
  - `record` with `completions` and optional `options` (`sort`, `case_sensitive`, `completion_algorithm`)
- Return `null` to fall back to Nushell file completion.
- Keep completers deterministic and fast. Do not perform expensive network calls unless the user explicitly wants that behavior.
- Prefer keeping completer helpers non-exported when used from modules, export only user-facing commands.
- For context-sensitive suggestions, accept `context: string`. Add `position: int` only when cursor-position logic is required.

## Common Patterns

### Custom command argument completion

```nu
def animals [] { [cat dog eel] }

def my-command [animal: string@animals] {
  print $animal
}
```

### `extern` positional and flag completion

```nu
def "nu-complete mytool envs" [] {
  [dev stage prod]
}

def "nu-complete mytool regions" [] {
  [us-east-1 us-west-2 eu-west-1]
}

export extern "mytool deploy" [
  env?: string@"nu-complete mytool envs"
  --region(-r): string@"nu-complete mytool regions"
]
```

### Dynamic completion from command output

```nu
def "nu-complete git branches" [] {
  ^git for-each-ref --format='%(refname:short)' refs/heads
  | lines
  | str trim
  | where $it != ""
}
```

### Context-aware completion

```nu
def "nu-complete pet names" [context: string] {
  let words = ($context | split words)
  let animal = ($words | last)

  match $animal {
    cat => [Missy Phoebe]
    dog => [Lulu Enzo]
    eel => [Eww Slippy]
    _ => []
  }
}
```

### Completion with descriptions and styles

```nu
def "nu-complete commits" [] {
  [
    { value: "5c2464", description: "Add .gitignore", style: red }
    { value: "f3a377", description: "Initial commit", style: { fg: green, attr: ub } }
  ]
}
```

## Validation Checklist

- Ensure completer names referenced by `@` are in scope when parsing the command.
- If module-based, re-run `use` so both completer and command are reparsed together.
- Run a syntax check for touched files (example: `nu -n -c 'source <path-to-file.nu>'`).
- Manually verify tab completion for each changed argument/flag.
- Verify fallback behavior (`null` means file completion) where applicable.

## Reference

- Primary docs: https://www.nushell.sh/book/custom_completions.html
- Read `references/templates.md` for copy-ready templates and troubleshooting.
