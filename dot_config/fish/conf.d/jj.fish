function jja
    if test (count $argv) -eq 0
        echo "Usage: ga <description>"
        return 1
    end

    set desc (string join " " $argv)
    set slug (string lower -- $desc)
    set slug (string replace -ar "\\s+" "-" -- $slug)
    set slug (string replace -ar "[^a-z0-9-]" "" -- $slug)
    set ws_name "agent-$slug"
    set repo_name (basename (pwd))
    set dest "../$repo_name--$ws_name"

    jj workspace add "$dest" --name "$ws_name" -r @
    cd "$dest"
    echo "Now in workspace: $ws_name"
end

function jjd
    set cwd (pwd)
    set base (basename "$cwd")
    set ws_name (string replace -r "^.+--" "" -- $base)

    if not string match -qr "^agent-" -- $ws_name
        echo "Refusing to nuke non-agent workspace"
        return 1
    end

    # Ensure working copy is fresh so forget succeeds.
    jj workspace update-stale >/dev/null 2>&1
    jj workspace forget "$ws_name"
    cd ..
    rm -rf -- "$base"
    echo "Nuked workspace $ws_name"
end

function jjs
    if not type -q fzf
        echo "fzf not found"
        return 1
    end
    if not jj root >/dev/null 2>&1
        echo "Not in a jj repo"
        return 1
    end

    set ws_name (jj workspace list | awk -F: '{print $1}' | fzf)
    if test -z "$ws_name"
        return 1
    end

    set root (jj workspace root)
    set parent (dirname "$root")
    set search_roots $parent
    if test -d "$HOME/Developer"
        set -a search_roots "$HOME/Developer"
    end
    set matches
    for sr in $search_roots
        for p in (find "$sr" -maxdepth 4 -type f -path "*/.jj/working_copy/checkout")
            if strings "$p" | grep -qx "$ws_name"
                set ws_path (dirname (dirname (dirname "$p")))
                set -a matches "$ws_path"
            end
        end
    end

    if test (count $matches) -gt 1
        set matches (printf "%s\n" $matches | sort -u)
    end

    if test (count $matches) -eq 0
        echo "Workspace path not found"
        return 1
    end

    if test (count $matches) -gt 1
        set ws_path (printf "%s\n" $matches | fzf)
    else
        set ws_path $matches[1]
    end

    if test -z "$ws_path"
        return 1
    end

    cd "$ws_path"
    echo "Now in workspace: $ws_path"
end
