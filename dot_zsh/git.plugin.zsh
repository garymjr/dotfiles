git_current_branch() {
  command git rev-parse --abbrev-ref HEAD 2>/dev/null
}

g() {
  if [[ $# -eq 0 ]]; then
    git status --short
  else
    git "$@"
  fi
}
alias ga='git add'
alias gaa='git add -A'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gc='git commit --verbose'
alias gca='git commit --verbose --amend'
alias gcmsg='git commit --message'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfo='git fetch origin'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gm='git merge'
alias gp='git pull'
alias grb='git rebase'
alias grs='git restore'
alias gs='git stash'
alias gst='git status'
alias gss='git status --short'
alias gsb='git status --short --branch'
alias gsw='git switch'
alias gwt='git worktree'

