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

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_history

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
alias oc='opencode attach http://localhost:4096 --dir $(pwd)'
alias t1="node $HOME/Developer/t1code/apps/tui/bin/t1code.js"

ocserver() {
  (
    opencode serve --hostname 0.0.0.0 --port 4096 &
    local pid=$!

    trap 'kill "$pid" 2>/dev/null' INT TERM HUP EXIT

    caffeinate -is -w "$pid"
    wait "$pid"
  )
}

wtcodex() {
  if ! command -v wt >/dev/null 2>&1; then
    echo "wtcodex: wt not found" >&2
    return 1
  fi

  if [[ ! -r /usr/share/dict/words ]]; then
    echo "wtcodex: /usr/share/dict/words is not readable" >&2
    return 1
  fi

  local -a words
  words=("${(@f)$(awk '
    /^[[:alpha:]]+$/ {
      w[++n] = tolower($0)
    }
    END {
      if (n < 2) {
        exit 1
      }
      srand()
      i = int(rand() * n) + 1
      j = int(rand() * (n - 1)) + 1
      if (j >= i) {
        j++
      }
      print w[i]
      print w[j]
    }
  ' /usr/share/dict/words)}")

  if [[ ${#words[@]} -ne 2 ]]; then
    echo "wtcodex: could not generate a branch name" >&2
    return 1
  fi

  local name="codex/${words[1]}-${words[2]}"
  wt switch --create "$name"
}

# direnv
# if command -v direnv >/dev/null 2>&1; then
#   eval "$(direnv hook zsh)"
# fi

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

# pnpm
export PNPM_HOME="/Users/gmurray/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
