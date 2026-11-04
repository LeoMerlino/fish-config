function bell_on_failure --on-event fish_postexec
    if test $status -ne 0
        printf '\a'
    end
end
