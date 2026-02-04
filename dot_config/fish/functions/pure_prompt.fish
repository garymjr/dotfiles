function pure_prompt
    if not set -q _pure_vi_mode
        set -g _pure_vi_mode 0
    end

    set -l ret $status
    set -l keymap ""
    if set -q fish_bind_mode
        if test "$fish_bind_mode" = "insert"
            set -g _pure_vi_mode 1
        end
        if test "$fish_bind_mode" = "default"; and test "$_pure_vi_mode" -eq 1
            set keymap "vicmd"
        end
    end

    set -l venv ""
    if set -q VIRTUAL_ENV
        set venv (string replace -r '.*/' '' -- "$VIRTUAL_ENV")
    end
    set venv (string trim -- "$venv")

    set -l jobs (count (jobs -p))

    set -l reset (printf '\e[0m')
    set -l bright_green (printf '\e[92m')
    set -l bright_yellow (printf '\e[93m')
    set -l bright_red (printf '\e[91m')
    set -l bright_magenta (printf '\e[95m')
    set -l bright_yellow_prompt (printf '\e[93m')
    set -l bright_cyan (printf '\e[96m')

    set -l insert_symbol "❯"
    set -l normal_symbol "❮"
    set -l job_symbol "●"

    set -l symbol "$insert_symbol"
    if test "$keymap" = "vicmd"
        set symbol "$normal_symbol"
    end

    set -l shell_color "$bright_red"
    if test "$symbol" = "$normal_symbol"
        set shell_color "$bright_yellow_prompt"
    else if test "$ret" = "0"
        set shell_color "$bright_magenta"
    end

    if test -n "$venv"
        printf '%s|%s|%s ' "$bright_green" "$venv" "$reset"
    end

    if test $jobs -gt 0
        printf '%s%s%s%s ' "$bright_yellow" "$job_symbol" "$jobs" "$reset"
    end

    printf '%s%s%s ' "$shell_color" "$symbol" "$reset"
end
