# --- Editors ---
set -x EDITOR hx
set -x VISUAL $EDITOR
set -x GIT_EDITOR $EDITOR

# --- FZF defaults ---
set -x FZF_DEFAULT_COMMAND 'fd --type file'
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

# --- Language/tooling env ---
# Elixir/Erlang
set -x KERL_BUILD_DOCS yes
set -x ERL_AFLAGS "-kernel shell_history enabled"

# Go
set -x GOPATH $HOME/go
set -x GOPROXY direct

# Shell path
set -x SHELL fish

# PATH setup
set -x PATH $PATH /opt/homebrew/bin
set -x PATH $PATH $HOME/bin
set -x PATH $PATH /usr/local/bin
set -x PATH $PATH $HOME/go/bin
set -x PATH $PATH $HOME/.cargo/bin
set -x PATH $PATH $HOME/.bun/bin
set -x PATH $PATH $HOME/.local/share/nvim/mason/bin
set -x PATH $PATH $HOME/.opencode/bin
set -x PATH $PATH $HOME/.local/bin

# Homebrew-provided client CLIs (if installed)
if command -q brew
    set brew_prefix (brew --prefix)
    if test -d $brew_prefix/opt/libpq/bin
        set -x PATH $PATH $brew_prefix/opt/libpq/bin
    end
    if test -d $brew_prefix/opt/mysql-client/bin
        set -x PATH $PATH $brew_prefix/opt/mysql-client/bin
    end
end

# --- Aliases ---
alias ls "eza --icons=always"
alias lg lazygit
alias chez chezmoi

# --- Tool integrations ---
if command -q ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
end

if command -q zoxide
    zoxide init fish | source
end

if test "$TERM_PROGRAM" = "WarpTerminal"
    # WarpTerminal specific - may need adaptation
else
    starship init fish | source
end

alias cursor "open -a Cursor"

# --- Local overrides ---
if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
