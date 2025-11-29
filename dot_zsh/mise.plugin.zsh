# TODO: 2024-01-03 remove rtx support
local __mise=mise
if (( ! $+commands[mise] )); then
  if (( $+commands[rtx] )); then
    __mise=rtx
  else
    return
  fi
fi

# Load mise hooks
eval "$($__mise activate zsh)"

# Hook mise into current environment
eval "$($__mise hook-env -s zsh)"

# Enhanced completion caching with error handling and timeout
_mise_completion_update() {
  local completion_file="$ZSH_CACHE_DIR/completions/_$__mise"
  local timeout=5
  
  # Ensure cache directory exists
  [[ -d "$ZSH_CACHE_DIR/completions" ]] || mkdir -p "$ZSH_CACHE_DIR/completions"
  
  # Generate completion with timeout protection
  if timeout $timeout $__mise completion zsh >| "$completion_file" 2>/dev/null; then
    # Success: autoload completion if not already loaded
    if [[ ! -f "$completion_file" ]] || [[ $_comps[$__mise] != "_$__mise" ]]; then
      typeset -g -A _comps
      autoload -Uz _$__mise
      _comps[$__mise]=_$__mise
    fi
  else
    # Failure: remove potentially broken completion file
    [[ -f "$completion_file" ]] && rm -f "$completion_file"
  fi
}

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `mise`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_$__mise" ]]; then
  typeset -g -A _comps
  autoload -Uz _$__mise
  _comps[$__mise]=_$__mise
fi

# Update completion asynchronously with error handling
_mise_completion_update &|
unset __mise
