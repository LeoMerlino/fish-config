function dmountbrowse
    set path (systemd-mount "$argv" 2>&1 | cut -d' ' -f7-)
    if test $pipestatus[1] -ne 0
        echo 'Command failed. Already mounted?'
        return 1
    end
    echo "Mounted at path: $path"
    fish -C "echo 'Browsing temporarily. Exit to unmount.' && cd $path"
    systemd-umount "$path"
    return $status
end
