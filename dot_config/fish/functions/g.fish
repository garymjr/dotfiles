function __fish__g
    if test (count $argv) -eq 0
        git log --all --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit
    else
        git $argv
    end
end

function g
    __fish__g $argv
end
