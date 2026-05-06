function rm
    if test (whoami) = root
        echo "Sudo no worky with this function - run as normal user or prepend with /bin/"
        return 1
    else
        set command /bin/rm
    end
    
    source /home/$USER/.config/fish/utils.fish
    if test (which fd) >/dev/null 2>&1
        set fd (which fd)
    else
        set fd /bin/fdfind
    end

    argparse -u -- $argv

    if test -z "$argv"
        elog "You moron. You supplied no args. Literally what was the point?"
        return 1
    end

    function delete
        for file in $argv[3..]
            set -a files \'$file\'
        end
        asktry $argv[1] $argv[2] --one-file-system "$files"
        # asktry $argv --one-file-system
        return $status
    end

    for f in $argv
        # Test if its not a file
        if not test -f "$f"
            set folder true
        end
        if not test -e "$f"
            elog "$f doesn't exist"
            return 1
        end
        # Test if files/directories can be deleted
        if not test -w (dirname "$f")
            set -a bad_files "$f"
        end
    end
    if not test -z "$bad_files"
        ask "You don't have permission to delete these files: $bad_files. Use sudo?" || return 1
        set command 'sudo /bin/rm'
    end

    if ! set -q folder
        delete $command "$argv_opts" $argv
        return $status
    end

    for f in $argv
        # Check if the argument is a mount point using findmnt
        if test -z $f # If array element is empty
            continue
        end
        set mounts (cut -d' ' -f2 /proc/mounts | grep -F "$f")
        if test $status -eq 0
            wlog "Folder contains the following mounts: "
            findmnt / | head -1
            for line in $mounts
                findmnt -n $line
            end
        end
    end
    set count ($fd -H . $argv | wc -l)
    echo
    wlog "About to delete $count file(s)!"
    delete "$command" "$argv_opts" "$argv"
end
