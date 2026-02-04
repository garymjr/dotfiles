function __pure_git_status -a cwd
    if not command -v git >/dev/null 2>&1
        return
    end

    set -l repo_root (command git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
    if test -z "$repo_root"
        return
    end

    set -l branch (command git -C "$cwd" symbolic-ref --quiet --short HEAD 2>/dev/null)
    if test -z "$branch"
        set -l hash (command git -C "$cwd" rev-parse --short=7 HEAD 2>/dev/null)
        if test -n "$hash"
            set branch "$hash"
        end
    end

    if test -z "$branch"
        return
    end

    set -l reset (printf '\e[0m')
    set -l cyan (printf '\e[36m')
    printf '%s%s%s' "$cyan" "$branch" "$reset"
end
