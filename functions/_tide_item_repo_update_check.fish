function _tide_item_repo_update_check
    if test -f ~/.config/repos.conf
        set repos (cat ~/.config/repos.conf)
    else
        echo "config$BR not found$RESET, add repos to$BY ~/.config/repos.conf"
    end
    function update_data
        echo -e '\n' > /tmp/repo_update_check
        for repo in $argv
            git -C "$repo" fetch >/dev/null 2>&1
            sed -i '1s/.*/'"$(date +%H)"'/' /tmp/repo_update_check
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
            sed -i '2s/.*/'"$(echo " $msg")"'/' /tmp/repo_update_check
        end
    end
    if ! test -f /tmp/repo_update_check; or test (head -1 /tmp/repo_update_check 2>/dev/null) != (date +%H)
        update_data $repos
    else
        tail -1 /tmp/repo_update_check
    end
end
