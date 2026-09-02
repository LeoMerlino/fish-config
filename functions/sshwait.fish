function sshwait
    while ! timeout 2s ssh $argv exit >/dev/null 2>&1
        :
    end
    ssh $argv
end
