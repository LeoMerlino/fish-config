if status is-interactive
abbr -a -- fixzlib 'i zlib lib32-zlib'

## Wacom Stuff
abbr -a -- wacom 'xsetwacom --set "Wacom Bamboo 2FG 4x5 Pen stylus" Button 2 pan && xsetwacom --set "Wacom Bamboo 2FG 4x5 Pen stylus"  "PanScrollThreshold" 200'
abbr -a -- enablewacom 'systemctl --user stop opentabletdriver.service && sudo modprobe -i wacom && sleep 1 && xsetwacom --set "Wacom Bamboo 2FG 4x5 Pen stylus" Button 2 pan && xsetwacom --set "Wacom Bamboo 2FG 4x5 Pen stylus"  "PanScrollThreshold" 200'
abbr -a -- disablewacom 'sudo modprobe -r wacom && systemctl --user start opentabletdriver.service'

## Flatpak
abbr -a -- fr 'flatpak remove'
abbr -a -- fs 'flatpak search'
abbr -a -- frd 'flatpak remove --delete-data'
abbr -a -- fi 'flatpak install'
abbr -a -- fu 'flatpak update'
abbr -a -- fl 'flatpak list'
abbr -a -- spotify-update "flatpak mask --remove com.spotify.Client && flatpak update com.spotify.Client -y && flatpak mask com.spotify.Client"

## File and Directory Management
abbr -a -- mkdir 'mkdir -p'

abbr -a -- cat 'bat'

# Alternatives   | og cmd | new cmd
alias ps='alternatives procs ps'


alias ls='eza --icons always --classify'
alias ks='eza --icons always --classify'
alias sl='eza --icons always --classify'
alias la='eza --icons always --classify -lA'
alias tree='eza --icons always --classify -T'
alias of='fd -H . . --type file | fzf'
alias fdd='fd -H . . --type directory | fzf'
alias fdf='kitten choose-files --mode file'
alias searchpath='commandline --replace (/bin/find $PATH 2>/dev/null | fzf)'

## Command Substitutions
abbr -a -- nano 'micro'
abbr -a -- rlk '/bin/readlink -f'
abbr -a -- pip 'uv pip'
abbr -a -- pip3 'uv pip'
abbr -a -- less 'less -R'
abbr -a -- grc 'grc --colour on'
abbr -a -- blkid 'grc blkid'
abbr -a -- somo 'sonar'
abbr -a -- rg 'rga-fzf'
abbr -a -- dua 'cull'
abbr -a -- lsblk 'lsblk -o NAME,SIZE,LABEL,MOUNTPOINTS'
abbr host 'systemd-resolve'

## git substitutions
abbr -a -- g 'git'
abbr -a -- gpl 'git pull'
abbr -a -- gps 'git push'
abbr -a -- gf 'git fetch'
abbr -a -- gl 'git log'
abbr -a -- ga 'git add'
abbr -a -- gs 'git status'
abbr -a -- gd 'git diff'
abbr -a -- gb 'git branch'
abbr -a -- gsw 'git switch'
abbr -a -- gc 'git clone -j$(nproc) --depth 1'
abbr gcm --set-cursor=! 'git commit -am "!"'
abbr -a -- grm 'git rm --cached'


## System Utilities
abbr -a -- dmount 'systemd-mount'
abbr -a -- dumount 'systemd-umount'
abbr -a -- restartghostty 'killall ghostty'
abbr -a -- nameof 'ps -o comm -p'
abbr -a -- fixpass 'faillock --user leo --reset'
abbr -a -- gpupowersave 'echo low | sudo tee /sys/class/drm/card1/device/power_dpm_force_performance_level'
abbr -a -- gpupower 'echo auto | sudo tee /sys/class/drm/card1/device/power_dpm_force_performance_level'
test $TERM = xterm-kitty && alias ssh='TERM=xterm-256color kitten ssh'
abbr -a -- df 'dysk -c+label,uuid'
abbr reloadmenu 'update-desktop-database ~/.local/share/applications'
alias klogout="qdbus6 org.kde.LogoutPrompt /LogoutPrompt org.kde.LogoutPrompt.promptLogout"
alias klogout-force="qdbus6 org.kde.Shutdown /Shutdown org.kde.Shutdown.logout"
alias kshutdown="qdbus6 org.kde.LogoutPrompt /LogoutPrompt promptShutDown"
alias kshutdown-force="qdbus6 org.kde.Shutdown /Shutdown org.kde.Shutdown.logoutAndShutdown"
alias kreboot="qdbus6 org.kde.LogoutPrompt /LogoutPrompt promptReboot"
alias kreboot-force="qdbus6 org.kde.Shutdown /Shutdown  org.kde.Shutdown.logoutAndReboot"
alias klock="qdbus6 org.kde.screensaver /ScreenSaver Lock"
alias khibernate="qdbus6 org.kde.Solid.PowerManagement /org/freedesktop/PowerManagement Hibernate"


## Miscellaneous
abbr -a -- aliases 'micro ~/.config/fish/conf.d/abbrs.fish'
abbr -a -- sctl '/usr/bin/systemctl'
abbr -a -- fixkvm 'sudo rmmod kvm_amd && sudo rmmod kvm'
abbr -a -- getclass "qdbus6 org.kde.KWin /KWin org.kde.KWin.queryWindowInfo | grep -E 'resourceName|resourceClass'"
abbr -a -- unlock 'faillock --user leo --reset'
abbr -a -- penv "if test -d .venv; else; uv venv -p 3.14 ; end && source .venv/bin/activate.fish"
abbr -a -- resource "source ~/.config/fish/conf.d/config.fish"
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
    abbr -a -- i 'paru -Sy --needed'
    abbr -a -- u 'upgrade'
    abbr -a -- um 'paru -Sy'
    abbr -a -- r 'paru -Rncs'
    abbr -a -- ss 'pacman -Q | grep'
    abbr -a -- pacman 'paru'
    abbr -a -- ratemirrors 'sudo cachyos-rate-mirrors'
    abbr -a -- ratemirrorsbad 'rate-mirrors --entry-country UK --max-jumps 1 --country-neighbors-per-country 1 --country-test-mirrors-per-country 6 --disable-comments-in-file --protocol https arch --max-delay 5200 | sudo tee /etc/pacman.d/mirrorlist && um'
else if string match -q $distro debian
    abbr -a -- i 'sudo apt install'
    function it
        sudo apt install $argv && sudo apt-mark auto $argv
    end
    abbr -a -- r 'sudo apt purge --autoremove'
    abbr -a -- u 'sudo apt update && sudo apt upgrade && flatpak update'
    abbr -a -- um 'sudo apt update'
    abbr -a -- upgradethenshutdown "sudo su -c 'apt update && apt upgrade -y && shutdown now'"
    abbr -a -- s 'apt search'
    abbr -a -- ss 'apt list --installed | grep'
    abbr -a -- cat 'batcat'
    alias fd='fdfind'
else if string match -q $distro fedora
    abbr -a -- i 'sudo dnf install'
    abbr -a -- r 'sudo dnf remove'
    abbr -a -- u 'sudo dnf upgrade --refresh'
    abbr -a -- upgradethenshutdown "sudo su -c 'flatpak update -y && dnf upgrade --refresh && shutdown now'"
    abbr -a -- s 'dnf search'
    abbr -a -- ss 'dnf list --installed | grep'
else if string match -q $distro alpine
    abbr -a -- i 'sudo apk add'
    abbr -a -- r 'sudo apk del'
    abbr -a -- u 'sudo apk upgrade'
    abbr -a -- upgradethenshutdown "sudo su -c 'flatpak update -y && apk upgrade && shutdown now'"
    abbr -a -- s 'apk search'
else if string match -q $distro gentoo
    abbr -a -- i 'sudo emerge -a --noreplace -gk --binpkg-respect-use=y '
    abbr -a -- r 'echo "Use rd to deselect them, then rr to depclean."'
    abbr -a -- rd 'sudo emerge --deselect'
    abbr -a -- rr 'sudo EMERGE_DEFAULT_OPTS='' emerge -ca'
    abbr -a -- s 'eix'
    abbr -a -- u 'read -P "You should sync (um) first also dont forget to snapshot!!!" && sudo emerge --ask --update --deep --changed-use --with-bdeps=y -gk --binpkg-respect-use=y @world  && echo "Remember to depclean!"'
    abbr -a -- um 'sudo mirrorselect -s3 -b10 -D -c "United Kingdom" && sudo EMERGE_DEFAULT_OPTS="" emerge --sync --quiet'
    alias uextra='kitty go-global-update & kitty cargo install-update -a & kitty flatpak update -y & kitty distrobox upgrade --all'
end
end
