[[ -o interactive ]] || return

export EDITOR='nvim'
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"
export CODEX_HOME="${HOME}/.codex"
export KERL_BUILD_DOCS='yes'
export ERL_AFLAGS='-kernel shell_history enabled'
export HOMEBREW_NO_ENV_HINTS=1
unset MAILCHECK MAIL MAILPATH mailpath
unsetopt MAIL_WARNING 2>/dev/null

[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

setopt autocd
setopt interactive_comments
bindkey -e

autoload -Uz compinit
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p "${_zcompdump:h}"
compinit -d "$_zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# 1Password CLI completion
if command -v op >/dev/null 2>&1; then
  eval "$(op completion zsh)"
fi

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first --color=always --icons=auto'
  alias ll='eza -lah --group-directories-first --git --color=always --icons=auto'
  alias la='eza -a --group-directories-first --color=always --icons=auto'
  alias l='eza --group-directories-first --color=always --icons=auto'
else
  alias ll='ls -lah'
  alias la='ls -A'
  alias l='ls -CF'
fi
alias lg='lazygit'

rcd() {
  local repo_root
  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || return
  builtin cd "$repo_root"
}

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# starship
if command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
  eval "$(starship init zsh)"
fi

if command -v atuin > /dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

# zsh-syntax-highlighting
for _zsh_hl in \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
  if [[ -r "$_zsh_hl" ]]; then
    source "$_zsh_hl"
    break
  fi
done
unset _zsh_hl _zcompdump
