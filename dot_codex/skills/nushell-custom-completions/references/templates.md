# Nushell Custom Completion Templates

Use these templates to speed up edits.

## 1) Static values

```nu
def "nu-complete <name>" [] {
  [value1 value2 value3]
}
```

## 2) Dynamic values from an external command

```nu
def "nu-complete <name>" [] {
  ^<cmd> <args>
  | lines
  | str trim
  | where $it != ""
}
```

## 3) Attach completion to a custom command

```nu
def "nu-complete colors" [] { [red green blue] }

def pick-color [color: string@"nu-complete colors"] {
  print $color
}
```

## 4) Attach completion to an `extern`

```nu
def "nu-complete tool profiles" [] {
  [default staging production]
}

export extern "tool deploy" [
  profile?: string@"nu-complete tool profiles"
  --profile(-p): string@"nu-complete tool profiles"
]
```

## 5) Return descriptions/styles

```nu
def "nu-complete refs" [] {
  [
    { value: "main", description: "Default branch", style: green }
    { value: "release", description: "Release branch", style: yellow }
  ]
}
```

Only `value` is inserted into the command line.

## 6) Return options and completions

```nu
def "nu-complete packages" [] {
  {
    options: {
      sort: false
      case_sensitive: false
      completion_algorithm: substring
    }
    completions: [nu_plugin_polars nu_plugin_formats nu_plugin_inc]
  }
}
```

## 7) Context-aware completer

```nu
def "nu-complete pet names" [context: string, position: int] {
  let words = ($context | split words)
  let animal = ($words | last)

  match $animal {
    cat => [Missy Phoebe]
    dog => [Lulu Enzo]
    _ => []
  }
}
```

Use `position` only if cursor placement changes behavior.

## Troubleshooting

- No suggestions shown:
  - Check that the completer name in `@...` exactly matches an in-scope `def`.
  - Re-source or re-import the module so parser metadata is refreshed.
- Wrong suggestions for context-aware completer:
  - Print/log parsed words temporarily, then remove debug output.
- Completion too slow:
  - Cache expensive lookups in an env var or temporary file and refresh on demand.
- Want built-in file completion as fallback:
  - Return `null` from the completer.
