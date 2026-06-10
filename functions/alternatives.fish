function alternatives
    if test $stubborn
        command $argv[2..-1]
        return 0
    end
    set BR (set_color --bold red)
    set BG (set_color --bold green)
    set B (set_color blue)
    set BB (set_color --bold blue)
    set BY (set_color --bold yellow)
    set RESET (set_color normal)
    read -P "Why not use$BY $argv[1]$RESET instead?$BY [y/n] $BG" -n 1 search
    echo $RESET
    switch (string lower "$search")
        case y
            commandline --replace "$argv[1] $argv[3..-1]"
        case n
            command $argv[2..-1]
            set -g stubborn very     
        case '*'
            return 1
    end
end
