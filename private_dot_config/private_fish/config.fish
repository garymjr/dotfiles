if status is-interactive
    set fish_greeting

    # Set $FZF_DEFAULT_COMMAND and $FZF_CTRL_T_COMMAND defaults
    set -x FZF_DEFAULT_COMMAND 'fd --type file'
    set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

    # Set $EDITOR
    # set -x EDITOR nvim
    # set -x VISUAL $EDITOR
    # set -x GIT_EDITOR $EDITOR

    # Set $PATH
    set -x PATH /opt/homebrew/bin $PATH
    set -x PATH ~/go/bin $PATH
    set -x PATH /usr/local/bin $PATH
    set -x PATH /opt/homebrew/opt/libpq/bin $PATH
    set -x PATH /opt/homebrew/opt/mysql-client/bin $PATH
    set -x PATH $HOME/.cargo/bin $PATH

    # Set $GOPROXY and $GOSUMDB
    set -x GOPROXY direct
    set -x GOSUMDB off

    # Define aliases
    alias ls eza
    alias chez chezmoi
    alias lg lazygit

    alias fanauth 'TERM=xterm-256color command fanauth'
    alias ssh 'TERM=xterm-256color command ssh'

    fzf_configure_bindings --directory=\ct --variables=\e\cv

    # Source local settings if they exist
    if test -s "$HOME/local.config.fish"
        source $HOME/local.config.fish
    end

    set -x SHELL (which fish)


    zoxide init fish | source
    starship init fish | source
end
