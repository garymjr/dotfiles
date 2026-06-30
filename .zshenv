export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state

# Homebrew environment
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac


# Keep PATH tidy and predictable.
typeset -U path PATH
typeset -a _path_prepend _existing_path_prepend
_path_prepend=(
  /usr/local/bin
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
  "$HOME/.bun/bin"
  "$HOME/.local/share/nvim/mason/bin"
  "$HOME/.opencode/bin"
  "$HOME/.local/bin"
  "$PNPM_HOME/bin"
  "$HOMEBREW_PREFIX/opt/libpq/bin"
)
for _p in "${_path_prepend[@]}"; do
  [[ -d "$_p" ]] && _existing_path_prepend+=("$_p")
done
path=("${_existing_path_prepend[@]}" $path)
unset _p _path_prepend _existing_path_prepend

# mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
