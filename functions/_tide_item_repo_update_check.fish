function _tide_item_repo_update_check
    if test -f ~/.config/repos.conf
        set repos (cat ~/.config/repos.conf)
    else
        echo "repo update check configuration$BR not found$RESET, add repos to$BY ~/.config/repos.conf"
    end
    for repo in $repos
        if ! test -f /tmp/last_fetch
            echo (date +%H) > /tmp/last_fetch
        end
        if test (cat /tmp/last_fetch) != (date +%H)
            git -C "$repo" fetch >/dev/null 2>&1 &
            echo (date +%H) > /tmp/last_fetch
        end
        set branch (git -C "$repo" symbolic-ref --quiet --short HEAD)
        set behind (git -C "$repo" rev-list --count HEAD..origin/"$branch")
        set ahead (git -C "$repo" rev-list --count origin/"$branch"..HEAD)
        set unstaged (git -C "$repo" status --porcelain | wc -l)
        set name (basename (git -C "$repo" remote get-url origin))
        set msg "repo$BY $name$RESET:"
        if test $behind = 0 -a $ahead = 0 -a $unstaged = 0
            continue
        end
        if test $behind -gt 0
            set msg "$BW$msg$BY $behind$RESET$BR behind$RESET"
        end
        if test $ahead -gt 0
            set msg "$BW$msg$BY $ahead$RESET$BG ahead$RESET"
        end
        if test $unstaged -gt 0
            set msg "$BW$msg$BY $unstaged$BC unstaged$RESET"
        end
        echo " $msg"
    end
end
