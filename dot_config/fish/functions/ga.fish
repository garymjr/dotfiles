function ga
    if test (count $argv) -eq 0
        set -l choice (command find .. -maxdepth 1 -type d -name 'agent--*' -print 2>/dev/null | sed 's|^\.\./||' | fzf --height=40%)
        if test -z "$choice"
            return 1
        end
        cd "../$choice"
        return 0
    end

    set -l src_pwd (pwd)
    set -l src_git (command git rev-parse --show-toplevel 2>/dev/null)
    set -l name "agent--$argv[1]"
    set -l target "$src_pwd/../$name"

    if test -d "$target"
        cd "$target"
        return 0
    end

    set -l origin (git remote get-url origin)
    set -l repo_name (basename $origin .git)
    set -l ref_repo "$HOME/git-mirrors/$repo_name.git"

    command mkdir -p "$HOME/git-mirrors"

    if test -d "$ref_repo"
        git -C "$ref_repo" fetch --all --prune
    else
        git clone --mirror "$origin" "$ref_repo"
    end

    git clone --reference "$ref_repo" "$origin" "$target"; or return 1

    set -l copy_list
    if set -q GA_COPY; and test -n "$GA_COPY"
        set copy_list $GA_COPY
    else
        set copy_list ".env"
    end

    for item in $copy_list
        if test -e "$src_pwd/$item"
            command rsync -a "$src_pwd/$item" "$target/"; or command cp -a "$src_pwd/$item" "$target/"; or printf "ga: copy failed: %s\n" "$src_pwd/$item" >&2
        else if test -n "$src_git" -a -e "$src_git/$item"
            command rsync -a "$src_git/$item" "$target/"; or command cp -a "$src_git/$item" "$target/"; or printf "ga: copy failed: %s\n" "$src_git/$item" >&2
        end
    end
    cd "$target"
end
