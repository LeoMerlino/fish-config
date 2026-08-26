function sshwait
    read -P "What ip? " addr
    while ! bash -c "cat <<<'' >/dev/tcp/$addr/22" 2>/dev/null
        sleep 1s
    end
    /bin/ssh $argv
end
