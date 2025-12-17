function __fish__guo
    git push -u origin (git branch --show-current)
end

function guo
    __fish__guo
end
