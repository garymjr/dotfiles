# COMPLETION FUNCTION
if (( ! $+commands[chezmoi] )); then
  return
fi

# Enhanced completion caching with error handling and timeout
_chezmoi_completion_update() {
  local completion_file="$ZSH_CACHE_DIR/completions/_chezmoi"
  local timeout=5
  
  # Ensure cache directory exists
  [[ -d "$ZSH_CACHE_DIR/completions" ]] || mkdir -p "$ZSH_CACHE_DIR/completions"
  
  # Generate completion with timeout protection
  if timeout $timeout chezmoi completion zsh >| "$completion_file" 2>/dev/null; then
    # Success: autoload completion if not already loaded
    if [[ ! -f "$completion_file" ]] || [[ $_comps[chezmoi] != "_chezmoi" ]]; then
      typeset -g -A _comps
      autoload -Uz _chezmoi
      _comps[chezmoi]=_chezmoi
    fi
  else
    # Failure: remove potentially broken completion file
    [[ -f "$completion_file" ]] && rm -f "$completion_file"
  fi
}

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `chezmoi`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_chezmoi" ]]; then
  typeset -g -A _comps
  autoload -Uz _chezmoi
  _comps[chezmoi]=_chezmoi
fi

# Update completion asynchronously with error handling
_chezmoi_completion_update &|

# ALIASES
alias cm='chezmoi'
alias cma='chezmoi add'
alias cmcd='chezmoi cd'
alias cme='chezmoi edit'
alias cmf='chezmoi forget'
alias cmg='chezmoi git'
alias cml='chezmoi ls'
alias cmlg="lazygit --path=$(chezmoi source-path)"
alias cmp='chezmoi apply'
alias cmr='chezmoi remove'
alias cmra='chezmoi re-add'
alias cms='chezmoi status'
alias cmu='chezmoi update'
alias cmm='chezmoi managed'
alias cmv='chezmoi verify'
