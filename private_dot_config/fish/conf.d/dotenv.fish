status --is-interactive || exit

set -q DOTENV_CACHE_DIR || set -g DOTENV_CACHE_DIR "$HOME/.cache/fish"
set -q DOTENV_VERBOSE || set -g DOTENV_VERBOSE false
set -g DOTENV_TRUSTED_FILE "$DOTENV_CACHE_DIR/trusted_envs"

function dotenv
    set -l file ".env"
    if test (count $argv) -gt 0
        set file $argv[1]
    end

    if not test -f $file
        echo "dotenv: File '$file' not found." >&2
        return 1
    end

    while read -l line
        # Trim whitespace
        set line (string trim $line)

        # Skip empty lines and comments
        if test -z "$line"; or string match -q "#*" $line
            continue
        end

        # Remove 'export ' if present
        if string match -q "export *" $line
            set line (string replace "export " "" $line)
        end

        # Split on '='
        set parts (string split "=" $line)
        if test (count $parts) -ne 2
            echo "dotenv: Invalid line: $line" >&2
            continue
        end

        set var $parts[1]
        set value $parts[2]

        # Set the variable globally
        set -gx $var $value
    end < $file

    if test "$DOTENV_VERBOSE" = true
        echo "dotenv: Loaded variables from '$file'" >&2
    end
end

function _dotenv_hook --on-variable PWD
    if test -f ".env"
        mkdir -p "$DOTENV_CACHE_DIR"
        if test -f "$DOTENV_TRUSTED_FILE"; and command grep -Fxq "$PWD" "$DOTENV_TRUSTED_FILE" 2>/dev/null
            dotenv
        else
            read -n 1 -f confirmation --prompt-str="dotenv: Found '.env' file. Import it? ([y]es/[N]o/[a]lways) "
            switch "$confirmation"
                case y Y
                    dotenv
                case a A
                    echo "$PWD" >> "$DOTENV_TRUSTED_FILE"
                    dotenv
                case '*'
                    if test "$DOTENV_VERBOSE" = true
                        echo "dotenv: Not importing." >&2
                    end
            end
        end
    end
end

_dotenv_hook