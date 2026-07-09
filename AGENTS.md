# AGENTS.md

## Source Of Truth

- This repo is intended to live at `~/.dotfiles`; do not move work to a sibling checkout.
- Managed home-directory targets are declared in `.config/mise/config.toml` under `[dotfiles]`; trust that table over README prose when they conflict.
- The shared global agent instructions are `.agents/AGENTS.md`; mise links that file to both `~/.codex/AGENTS.md` and `~/.config/opencode/AGENTS.md`.
- Root `AGENTS.md` is repo-specific guidance for this dotfiles checkout, not the global agent instruction file.

## Commands

- First bootstrap from a fresh clone: `mise --config ~/.dotfiles/.config/mise/config.toml bootstrap`.
- Normal setup/apply flow: `mise install` then `mise dotfiles apply`.
- Verify managed links after dotfile changes: `mise dotfiles status`.
- Add new managed files with `mise dotfiles add ~/.path/to/file`; do not hand-maintain symlinks or duplicate `[dotfiles]` entries.

## Editing Rules

- Keep tracked config changes in this repo; live files in `$HOME` should be symlinks managed by mise.
- If changing opencode config, preserve `$schema` in `.config/opencode/opencode.json`; opencode validates config strictly and needs a restart to load changes.
- Do not commit machine-local state: Lazygit `state.yml`, Herdr logs/sockets/session/release files, `.DS_Store`, or local Opencode install/dependency files.
- `.config/opencode/AGENTS.md` is ignored because it is a generated symlink target; edit `.agents/AGENTS.md` instead.

## Structure Notes

- Neovim is LazyVim-based; local plugin overrides live in `.config/nvim/lua/plugins`.
- Codex user config, keybindings, browser config, selected automations, and skills live under `.codex`.
- Opencode config is under `.config/opencode`; TUI config is split across `tui.json` and `tui.toml`.
- Herdr config is `.config/herdr/config.toml`; the rest of that directory may contain runtime state.
