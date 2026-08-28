if status is-interactive
abbr fixzlib 'i zlib lib32-zlib'

## Wacom Stuff
abbr wacom 'xsetwacom --set "Wacom Bamboo 2FG 4x5 Pen stylus" Button 2 pan && xsetwacom --set "Wacom Bamboo 2FG 4x5 Pen stylus"  "PanScrollThreshold" 200'
abbr enablewacom 'systemctl --user stop opentabletdriver.service && sudo modprobe -i wacom && sleep 1 && xsetwacom --set "Wacom Bamboo 2FG 4x5 Pen stylus" Button 2 pan && xsetwacom --set "Wacom Bamboo 2FG 4x5 Pen stylus"  "PanScrollThreshold" 200'
abbr disablewacom 'sudo modprobe -r wacom && systemctl --user start opentabletdriver.service'

## Flatpak
abbr fr 'flatpak remove'
abbr fs 'flatpak search'
abbr frd 'flatpak remove --delete-data'
abbr fi 'flatpak install'
abbr fu 'flatpak update'
abbr fl 'flatpak list'
abbr spotify-update "flatpak mask --remove com.spotify.Client && flatpak update com.spotify.Client -y && flatpak mask com.spotify.Client"

## File and Directory Management
abbr mkdir 'mkdir -p'

abbr cat 'bat'

# Alternatives   | new cmd | og cmd
alias ps='alternatives procs ps'
alias netstat='alternatives lsoff netstat'
alias ss='alternatives ss lsoff'

alias ls='eza --icons always --classify auto'
alias ks='eza --icons always --classify auto'
alias sl='eza --icons always --classify auto'
alias la='eza --icons always --classify auto -lA'
alias tree='eza --icons always --classify auto -T'
alias of='commandline --replace "ls $(fd -H . . --type file | fzf)"'
alias fdd='commandline --replace "ls $(fd -H . . --type directory | fzf)"'
alias fdf='kitten choose-files --mode file'
alias searchpath='echo "Just press ctrl + v" && sleep 1 && commandline --replace (/bin/find $PATH 2>/dev/null | fzf)'
alias searchenv='commandline --replace (env | fzf)'


## Command Substitutions
abbr nano 'micro'
abbr --set-cursor=! rlk 'readlink -f ! | kitten clipboard '
abbr pip 'uv pip'
abbr pip3 'uv pip'
abbr less 'less -R'
abbr grc 'grc --colour on'
abbr blkid 'grc blkid'
abbr somo 'sonar'
abbr rg 'rga-fzf'
abbr dua 'cull'
abbr lsblk 'lsblk -o NAME,SIZE,LABEL,MOUNTPOINTS'
abbr wget 'aria2c -s 4 -Z'
abbr host 'systemd-resolve'

## git substitutions
abbr g 'git'
abbr gpl 'git pull'
abbr gps 'git push'
abbr gf 'git fetch'
abbr grs 'git reset'
abbr gsh 'git show'
abbr grh 'git reset --hard'
abbr gl 'git log'
abbr ga 'git add'
abbr gs 'git status'
abbr gd 'git diff'
abbr gb 'git branch'
abbr gsw 'git switch'
abbr gc 'git clone -j$(nproc) --depth 1'
abbr gch 'git checkout'
abbr gam 'git commit --amend --no-edit -a'
abbr gcm --set-cursor=! 'git commit -am "!"'
abbr grm 'git rm --cached'


## System Utilities
abbr dmount 'systemd-mount'
abbr dumount 'systemd-umount'
abbr restartghostty 'killall ghostty'
abbr nameof 'ps -o comm -p'
abbr fixpass 'faillock --user leo --reset'
abbr gpupowersave 'echo low | sudo tee /sys/class/drm/card1/device/power_dpm_force_performance_level'
abbr gpupower 'echo auto | sudo tee /sys/class/drm/card1/device/power_dpm_force_performance_level'
test $TERM = xterm-kitty && alias ssh='TERM=xterm-256color kitten ssh'
abbr df 'dysk -c+label,uuid'
abbr reloadmenu 'update-desktop-database ~/.local/share/applications'
abbr own 'sudo chown -R $USER:'
abbr eject 'udisksctl power-off -b'
alias klogout="qdbus6 org.kde.LogoutPrompt /LogoutPrompt org.kde.LogoutPrompt.promptLogout"
alias klogout-force="qdbus6 org.kde.Shutdown /Shutdown org.kde.Shutdown.logout"
alias kshutdown="qdbus6 org.kde.LogoutPrompt /LogoutPrompt promptShutDown"
alias kshutdown-force="qdbus6 org.kde.Shutdown /Shutdown org.kde.Shutdown.logoutAndShutdown"
alias kreboot="qdbus6 org.kde.LogoutPrompt /LogoutPrompt promptReboot"
alias kreboot-force="qdbus6 org.kde.Shutdown /Shutdown  org.kde.Shutdown.logoutAndReboot"
alias klock="qdbus6 org.kde.screensaver /ScreenSaver Lock"
alias khibernate="qdbus6 org.kde.Solid.PowerManagement /org/freedesktop/PowerManagement Hibernate"


## Miscellaneous
abbr aliases 'micro ~/.config/fish/conf.d/abbrs.fish'
abbr sctl 'systemctl'
abbr fixkvm 'sudo rmmod kvm_amd && sudo rmmod kvm'
abbr getclass "qdbus6 org.kde.KWin /KWin org.kde.KWin.queryWindowInfo | grep -E 'resourceName|resourceClass'"
abbr unlock 'faillock --user leo --reset'
abbr penv "if test -d .venv; else; uv venv -p 3.14 ; end && source .venv/bin/activate.fish"
abbr resource "source ~/.config/fish/conf.d/config.fish"
function run
    chmod +x $argv[1]
    eval $argv
end


## Package Management

if test (which pacman 2>/dev/null)
    set distro "arch"
    function fish_command_not_found
        asktry pkgfile "$argv[1]" || asktry findinpackage "$argv[1]"
    end
else if test (which apt-get 2>/dev/null)
    set distro "debian"
    function fish_command_not_found
        asktry apt-file find "$argv[1]"
    end
else if test (which dnf 2>/dev/null)
    set distro "fedora"

else if test (which apk 2>/dev/null)
    set distro "alpine"
    
else if test (which emerge 2>/dev/null)
    set distro "gentoo"
    function fish_command_not_found
        asktry "e-file $argv[1] || eix $argv[1]"
    end
end

if string match -q $distro arch
    abbr i 'paru -Sy --needed'
    abbr u 'upgrade'
    abbr um 'paru -Sy'
    abbr r 'paru -Rncs'
    abbr ss 'pacman -Q | grep'
    abbr pacman 'paru'
    abbr ratemirrors 'sudo cachyos-rate-mirrors'
    abbr ratemirrorsbad 'rate-mirrors --entry-country UK --max-jumps 1 --country-neighbors-per-country 1 --country-test-mirrors-per-country 6 --disable-comments-in-file --protocol https arch --max-delay 5200 | sudo tee /etc/pacman.d/mirrorlist && um'
else if string match -q $distro debian
    abbr i 'sudo apt install'
    function it
        sudo apt install $argv && sudo apt-mark auto $argv
    end
    abbr r 'sudo apt autopurge'
    abbr u 'sudo apt update && sudo apt upgrade && sudo apt autopurge && flatpak update'
    abbr um 'sudo apt update'
    abbr upgradethenshutdown "sudo su -c 'apt update && apt upgrade -y && shutdown now'"
    abbr s 'apt search'
    abbr ss 'apt list --installed | grep'
    abbr cat 'batcat'
    alias fd='fdfind'
else if string match -q $distro fedora
    abbr i 'sudo dnf install'
    abbr r 'sudo dnf remove'
    abbr u 'sudo dnf upgrade --refresh'
    abbr upgradethenshutdown "sudo su -c 'flatpak update -y && dnf upgrade --refresh && shutdown now'"
    abbr s 'dnf search'
    abbr ss 'dnf list --installed | grep'
else if string match -q $distro alpine
    abbr i 'sudo apk add'
    abbr r 'sudo apk del'
    abbr u 'sudo apk upgrade'
    abbr upgradethenshutdown "sudo su -c 'flatpak update -y && apk upgrade && shutdown now'"
    abbr s 'apk search'
else if string match -q $distro gentoo
    abbr i 'sudo emerge -a --noreplace'
    abbr r 'echo "Use rd to deselect them, then rr to depclean."'
    abbr rd 'sudo emerge --deselect'
    abbr rr 'sudo EMERGE_DEFAULT_OPTS='' emerge -ca'
    abbr s 'eix'
    abbr u 'read -P "You should sync (um) first also dont forget to snapshot!!!" && sudo emerge --ask --update --deep --changed-use --binpkg-respect-use=y @world && echo "Remember to depclean!"'
    abbr um 'sudo EMERGE_DEFAULT_OPTS="" emerge --sync --quiet'
    abbr ratemirrors 'sudo mirrorselect -s3 -b10 -D -c "United Kingdom"'
    alias uextra='kitty go-global-update & kitty cargo install-update -a & kitty flatpak update -y & kitty distrobox upgrade --all & wait'
end
end
