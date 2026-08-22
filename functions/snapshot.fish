function snapshot
    set name "snap-$(date +%m-%d-%Y)"
    if test -d /.snapshots/"$name"
        for i in (seq 1 50)
            test -d /.snapshots/"$name:$i" || { set name "$name:$i"; break; }
        end
    end
    log "Creating snapshot..."
    asktry "sudo btrfs subvolume snapshot -r / /.snapshots/$name" || return 1
    slog "Successfully created snapshot!"
    if test (count /.snapshots/snap-*) -gt 2
        set snapshots (/bin/ls /.snapshots/snap-*)
        set oldest_date (date -d (string replace -ra ':(\d+)$' '' -- $snapshots[1] | string replace -a '-' '/') +%s)
        set oldest_name $snapshots[1]

        for snapshot in $snapshots
            set base_date (string replace -ra ':\d+$' '' -- $snapshot)
            set ts (date -d (string replace -a '-' '/' $base_date) +%s)
            if test $ts -lt $oldest_date
                set oldest_date $ts
                set oldest_name $snapshot
            end
        end
        if ask "You have more than two snapshots. Delete the oldest one?"
            asktry "sudo btrfs subvolume delete /.snapshots/$oldest_name"
        end
    end
    return 0
end
