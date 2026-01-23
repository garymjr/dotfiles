function __pure_shorten_path -a path
    set -l home "$HOME"
    set -l friendly "$path"

    if test -n "$home"; and string match -q -- "$home*" "$path"
        set -l start (math (string length -- "$home") + 1)
        set -l suffix (string sub -s $start -- "$path")
        set friendly "~$suffix"
    end

    if test "$friendly" = "/"
        echo "/"
        return
    end

    set -l raw_parts (string split '/' -- "$friendly")
    set -l parts
    for part in $raw_parts
        if test -z "$part"
            continue
        end
        set parts $parts "$part"
    end

    set -l count_parts (count $parts)
    if test $count_parts -eq 0
        echo "/"
        return
    end

    if test $count_parts -le 2
        echo (string join '/' -- $parts)
        return
    end

    set -l out_parts
    for idx in (seq 1 $count_parts)
        set -l part $parts[$idx]
        if test $idx -eq 1; or test $idx -eq $count_parts
            set out_parts $out_parts "$part"
        else
            if string match -q -- ".*" "$part"
                set -l part_len (string length -- "$part")
                set -l sub_len 2
                if test $part_len -lt 2
                    set sub_len $part_len
                end
                set out_parts $out_parts (string sub -l $sub_len -- "$part")
            else
                set out_parts $out_parts (string sub -l 1 -- "$part")
            end
        end
    end

    echo (string join '/' -- $out_parts)
end
