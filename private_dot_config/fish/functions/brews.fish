function __fish__brews
    set formulae (brew leaves | xargs brew deps --installed --for-each)
    set casks (brew list --cask 2>/dev/null)

    set_color blue
    echo -n "==> "
    set_color normal
    set_color --bold
    echo "Formulae"
    set_color normal
    
    for line in $formulae
        echo $line | sed 's/:/: /'
    end
    
    echo
    set_color blue
    echo -n "==> "
    set_color normal
    set_color --bold
    echo "Casks"
    set_color normal
    echo $casks
end

function brews
    __fish__brews
end
