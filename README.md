# Dotfiles

Personal macOS dotfiles managed by `mise dotfiles`.

This repository is intended to live at `~/.dotfiles`. The live home-directory
files are symlinks declared in `.config/mise/config.toml`, with
`dotfiles.root = "~/.dotfiles"`.

## Managed files

- Shell startup: `.zshrc`, `.zshenv`
- Git defaults: `.gitconfig`
- Mise runtime, bootstrap, macOS defaults, and dotfile mapping:
  `.config/mise/config.toml`
- Neovim configuration: `.config/nvim`
- Prompt configuration: `.config/starship.toml`
- Herdr configuration: `.config/herdr/config.toml`
- Opencode configuration: `.config/opencode`
- Ghostty configuration: `Library/Application Support/com.mitchellh.ghostty`
- Lazygit configuration: `Library/Application Support/lazygit`
- Codex configuration, rules, skills, keybindings, browser config, and selected
  automations under `.codex`
- Shared agent instructions, skills, and plugin marketplace metadata under
  `.agents`

The current setup uses symlinks for managed dotfiles.

## Bootstrap

Install mise, then clone this repository to `~/.dotfiles`. The mise config is
self-managing: the `[dotfiles]` table links `~/.config/mise/config.toml` from
this repo, so the first run does not need a hand-maintained config symlink.

On the first run, point mise at the cloned config and bootstrap from it:

```sh
mise --config ~/.dotfiles/.config/mise/config.toml bootstrap
```

After that, normal mise commands can use the linked config:

```sh
mise install
mise dotfiles apply
```

`mise bootstrap` applies dotfiles explicitly, including the self-managed mise
config, and also handles the Homebrew packages and macOS defaults declared under
`[bootstrap.*]`.

## Day-to-day commands

Use mise as the source of truth:

```sh
mise dotfiles status
mise dotfiles apply
```

`mise dotfiles status` shows each configured target, source, mode, and whether it
is applied. `mise dotfiles apply` creates or updates the managed symlinks.

## Add or update a managed file

Use `mise dotfiles add` so mise updates the `[dotfiles]` configuration instead
of hand-maintaining links:

```sh
mise dotfiles add ~/.path/to/file
```

After adding a file, verify the result:

```sh
mise dotfiles status
git status --short
```

## Notes

- `.zshenv` initializes Homebrew, pnpm, mise, worktrunk, and common PATH
  entries.
- `.zshrc` configures interactive shell behavior, completions, aliases, zoxide,
  starship, atuin, and zsh syntax highlighting.
- Neovim is based on LazyVim with local plugin overrides in
  `.config/nvim/lua/plugins`.
- Codex skills and rules are tracked here intentionally; generated plugin cache
  directories are not.
- `.agents/AGENTS.md` is linked into both `~/.codex/AGENTS.md` and
  `~/.config/opencode/AGENTS.md`.
- Herdr session, socket, release-note, and log files are local state and are not
  tracked.

## Safety

Do not commit credentials, tokens, private keys, production data, shell history,
or machine-local state. The repository intentionally ignores Lazygit's mutable
state file, Herdr runtime state, and local Opencode dependency/install metadata.
