# --- general aliases ---
alias ls="eza --icons=always"
alias lg=lazygit
alias chez=chezmoi
alias code=code-insiders
alias dbui="nvim -c DBUI"
alias nv=nvim

alias oc=opencode
alias occ="opencode -m opencode/big-pickle run 'commit the staged changes'"

# --- git aliases ---
alias ga='git add'
alias gb='git branch'
alias gc='git commit --verbose'
alias 'gc!'='git commit --amend --verbose'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfo='git fetch origin'
alias gm='git merge'
alias gp='git pull'
alias gr='git reset'
alias grb='git rebase'
alias grs='git restore'
alias gs='git status --short'
alias gst='git stash'
alias gsw='git switch'
alias gu='git push'
alias guf='git push --force-with-lease'
alias 'guf!'='git push --force'
alias gwt='git worktree'

alias ccu='npx @ccusage/codex@latest'

# --- brew aliases ---
if command -v brew &>/dev/null
    alias ba='brew autoremove'
    alias bcfg='brew config'
    alias bci='brew info --cask'
    alias bcin='brew install --cask'
    alias bcl='brew list --cask'
    alias bcn='brew cleanup'
    alias bco='brew outdated --cask'
    alias bcrin='brew reinstall --cask'
    alias bcubc='brew upgrade --cask && brew cleanup'
    alias bcubo='brew update && brew outdated --cask'
    alias bcup='brew upgrade --cask'
    alias bdr='brew doctor'
    alias bfu='brew upgrade --formula'
    alias bi='brew install'
    alias bl='brew list'
    alias bo='brew outdated'
    alias brewp='brew pin'
    alias brewsp='brew list --pinned'
    alias bs='brew search'
    alias bsl='brew services list'
    alias bsoff='brew services stop'
    alias bsoffa='bsoff --all'
    alias bson='brew services start'
    alias bsona='bson --all'
    alias bsr='brew services run'
    alias bsra='bsr --all'
    alias bu='brew update'
    alias bubo='brew update && brew outdated'
    alias bubu='bubo && bup'
    alias bubug='bubo && bugbc'
    alias bugbc='brew upgrade --greedy && brew cleanup'
    alias bup='brew upgrade'
    alias buz='brew uninstall --zap'
end

# --- chezmoi aliases ---
if command -v chezmoi &>/dev/null
    alias cm='chezmoi'
    alias cma='chezmoi add'
    alias cmcd='chezmoi cd'
    alias cme='chezmoi edit'
    alias cmf='chezmoi forget'
    alias cmg='chezmoi git'
    alias cml='chezmoi ls'
    alias cmlg="lazygit --path=(chezmoi source-path)"
    alias cmp='chezmoi apply'
    alias cmr='chezmoi remove'
    alias cmra='chezmoi re-add'
    alias cms='chezmoi status'
    alias cmu='chezmoi update'
    alias cmm='chezmoi managed'
    alias cmv='chezmoi verify'
end
