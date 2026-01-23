function gd
    set -l dir (pwd)
    set -l base (basename $dir)

    if not string match -q 'agent--*' $base
        return 1
    end

    set -l force 0
    if contains -- --force $argv
        set force 1
    end

    set -l dirty 0
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        if test (count (git status --porcelain)) -gt 0
            set dirty 1
        end
    end

    if test $dirty -eq 1 -a $force -eq 0
        echo "Uncommitted changes. Use gd --force to delete."
        return 1
    end

    cd ..
    trash $base
end
