function fish_prompt
    # Left prompt: green '❯' if successful, red if failed
    if not test $status -eq 0
        set_color red
    else
        set_color green
    end
    echo -n "❯ "
    set_color normal

    # Right prompt: blue current directory (shortened), red background job indicator, yellow exit code if failed
    set_color blue
    echo -n (prompt_pwd)
    set_color normal

    if test -n "(jobs -c 2>/dev/null)"
        set_color red
        echo -n " ⏻"
        set_color normal
    end

    if not test $status -eq 0
        set_color yellow
        echo -n " ($status)"
        set_color normal
    end
    echo
end
