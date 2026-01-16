fish_config theme choose "Catppuccin Mocha"

set -gx EDITOR nvim
set -gx VISUAL $EDITOR
set -gx GIT_EDITOR $EDITOR

set -gx KERL_BUILD_DOCS yes
set -gx ERL_AFLAGS "-kernel shell_history enabled"

set -gx GOPATH $HOME/go
set -gx GOPROXY direct

set -gx SHELL (which fish)

set -gx OPENCODE_DISABLE_AUTOCOMPACT 1

set -U fish_greeting

fish_add_path -g /opt/homebrew/bin
fish_add_path -g $HOME/bin
fish_add_path -g /usr/local/bin
fish_add_path -g $HOME/go/bin
fish_add_path -g $HOME/.cargo/bin
fish_add_path -g $HOME/.bun/bin
fish_add_path -g $HOME/.local/share/nvim/mason/bin
fish_add_path -g $HOME/.opencode/bin
fish_add_path -g $HOME/.local/bin

# homebrew-provided client clis
if command -v brew &>/dev/null
    set brew_prefix (brew --prefix)
    for brew_dir in libpq/bin mysql-client/bin
        if test -d $brew_prefix/opt/$brew_dir
            fish_add_path -g $brew_prefix/opt/$brew_dir
        end
    end
end

if command -v mise &>/dev/null
    mise activate fish | source
end

if command -v zoxide &>/dev/null
    zoxide init fish | source
end

direnv hook fish | source

# fish_vi_key_bindings
pure init --no-detailed fish | source

if command -v fzf &>/dev/null
    if command -v fd &>/dev/null
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
        set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    else if command -v rg &>/dev/null
        set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --glob "!.git/*"'
        set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    end
    fzf --fish | source
end

if command -v bun &>/dev/null
    if not test -f $HOME/.config/fish/completions/bun.fish
        mkdir -p $HOME/.config/fish/completions
        bun completions fish >$HOME/.config/fish/completions/bun.fish 2>/dev/null
    end
end

if command -v gh &>/dev/null
    if not test -f $HOME/.config/fish/completions/gh.fish
        mkdir -p $HOME/.config/fish/completions
        gh completion --shell fish >$HOME/.config/fish/completions/gh.fish 2>/dev/null
    end
end

if command -v chezmoi &>/dev/null
    if not test -f $HOME/.config/fish/completions/chezmoi.fish
        mkdir -p $HOME/.config/fish/completions
        chezmoi completion fish >$HOME/.config/fish/completions/chezmoi.fish 2>/dev/null
    end
end

fish_add_path -g $HOME/.antigravity/antigravity/bin

if status is-interactive
end
