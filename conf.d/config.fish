if status is-interactive

# Fix backwards prompt
set -g fish_key_bindings fish_hybrid_key_bindings

function upgrade
    if ! test -e /tmp/mirrorsdone
        sudo cachyos-rate-mirrors &
        touch /tmp/mirrorsdone
    end
    go-global-update &
    cargo install-update -a &
    flatpak update -y
    if /bin/pacman -Qu | grep -q plasma
        set rebuild true
    end
    wait
    paru -Syu --batchinstall --cleanafter
    if set -q rebuild
        paru -S --rebuild --noconfirm --quiet kwin-effects-glass-git
    end
end

function upgradeunattended
    if ! test -e /tmp/mirrorsdone
        sudo cachyos-rate-mirrors && touch /tmp/mirrorsdone &
    end
    flatpak update -y &
    go-global-update &
    cargo install-update -a &
    if /bin/pacman -Qu | grep -q plasma
        set rebuild true
    end
    paru -Syu --batchinstall --cleanafter --noconfirm
    if set -q rebuild
        paru -S --rebuild --noconfirm --quiet kwin-effects-glass-git
    end
end

function upgradethenshutdown
    upgradeunattended
    sudo systemctl shutdown
end

function upgradethenreboot
    upgradeunattended
    sudo systemctl reboot
end


complete -e rm
complete -e tar
complete -e unzip
complete -e du

end
source /home/$USER/.config/fish/colours.fish
source /home/$USER/.config/fish/utils.fish
set -gx EDITOR /usr/bin/micro
zoxide init fish --cmd cd | source
fzf --fish | source
echo Rmemver to do the funny call thing where theyu forgot therir hnoe but didnt
