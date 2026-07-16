function sshwait
    read -P "What ip? " addr
    while ! bash -c "cat <<<'' >/dev/tcp/$addr/22"
        sleep 1s
    end
    /bin/ssh $argv
end
