# COMPLETION FUNCTION
if (( ! $+commands[chezmoi] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `chezmoi`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_chezmoi" ]]; then
  typeset -g -A _comps
  autoload -Uz _chezmoi
  _comps[chezmoi]=_chezmoi
fi

chezmoi completion zsh >| "$ZSH_CACHE_DIR/completions/_chezmoi" &|

# ALIASES
alias cm='chezmoi'
alias cma='chezmoi add'
alias cmcd='chezmoi cd'
alias cme='chezmoi edit'
alias cmg='chezmoi git'
alias cml='chezmoi ls'
alias cmp='chezmoi apply'
alias cmr='chezmoi remove'
alias cms='chezmoi status'
alias cmu='chezmoi update'
alias cmm='chezmoi managed'
alias cmv='chezmoi verify'
