function _tide_item_repo_update_check
    if test -f ~/.config/repos.conf
        set repos (cat ~/.config/repos.conf)
    else
        echo "repo update check configuration$BR not found$RESET, add repos to$BY ~/.config/repos.conf"
    end
    for i in (seq (count $repos))
        if ! test -f /tmp/last_fetch
            echo (date +%H) > /tmp/last_fetch
        end
        if test (cat /tmp/last_fetch) != (date +%H)
            git -C "$repos[$i]" fetch >/dev/null 2>&1 &
            echo (date +%H) > /tmp/last_fetch
        end
        set branch (git -C "$repos[$i]" symbolic-ref --quiet --short HEAD)
        set remote (git -C "$repos[$i]" remote)
        set behind (git -C "$repos[$i]" rev-list --count HEAD.."$remote"/"$branch")
        set ahead (git -C "$repos[$i]" rev-list --count "$remote"/"$branch"..HEAD)
        set unstaged (git -C "$repos[$i]" status --porcelain | wc -l)
        set name (basename (git -C "$repos[$i]" remote get-url "$remote"))
        set msg "$BY $name$RESET:"
        if test $behind = 0 -a $ahead = 0 -a $unstaged = 0
            if test "$i" = (count $repos)
                printf '\e[3D\e[3X'
            end
            continue
        end
        if test $behind -gt 0
            set msg "$BW$msg$BW $behind$RESET$BR b$RESET"
        end
        if test $ahead -gt 0
            set msg "$BW$msg$BW $ahead$RESET$BG a$RESET"
        end
        if test $unstaged -gt 0
            set msg "$BW$msg$BW $unstaged$BB u$RESET"
        end
        echo -n "$msg"
        if test "$i" != (count $repos)
            echo -n "$BGR ──"
        end
    end
end
