function __fish__git_current_branch
    git rev-parse --abbrev-ref HEAD 2>/dev/null
end

function git_current_branch
    __fish__git_current_branch
end
