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
alias gb='git branch'
alias gc='git commit --verbose'
alias gc!='git commit --amend --verbose'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfo='git fetch origin'
alias gl='git log --all --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gm='git merge'
alias gp='git pull'
alias gr='git reset'
alias grb='git rebase'
alias grs='git restore'
alias gs='git stash'
alias gsw='git switch'
alias gu='git push'
alias guf='git push --force-with-lease'
alias guf!='git push --force'
guo() {
  git push -u origin $(git branch --show-current)
}
alias gwt='git worktree'

