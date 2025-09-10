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

    echo "dotenv: Loaded variables from '$file'" >&2
end