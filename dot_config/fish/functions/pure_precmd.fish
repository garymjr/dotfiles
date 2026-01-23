function pure_precmd
    set -l cwd (pwd -P)
    set -l short_path (__pure_shorten_path "$cwd")

    set -l reset (printf '\e[0m')
    set -l blue (printf '\e[34m')

    printf '\n%s%s%s' "$blue" "$short_path" "$reset"

    set -l git_status (__pure_git_status "$cwd")
    if test -n "$git_status"
        printf ' %s' "$git_status"
    end

    printf '\n'
end
