function log
    echo $BW"[INFO] $argv"$RESET
end

function wlog
    echo $BO"[WARN] $argv"$RESET
end

function elog
    echo $BR"[ERROR] $argv"$RESET
end

function slog
    echo "[INFO]$BG $argv"$RESET
end

# function pick
#     echo 'Pick from the following items:' 1>&2
#     for item in (seq (count $argv))
#         echo "$item. $argv[$item]" 1>&2
#     end
#     while :
#         read -P 'Choice: ' choice 1>&2 || return 1
#         { test $choice -gt 0 2>/dev/null; and test $choice -lt (math (count $argv)+1) 2>/dev/null; } || { echo 'Invalid choice' 1>&2; continue; }
#         echo "$choice"
#         return 0
#     end
# end

function try
    log "Running command => `$BY$argv$RESET`"
    eval "$argv" || { elog "Command failed! Exiting." && return 1 }
    return $status
end

function ask
    read search -P $BW"$argv"$BW" "[{$BG}y{$BW}/{$BR}N{$BW}]$BB" "➜$BC" "
    switch (string lower "$search")
        case y
            return 0
        case '*'
            return 1
    end
end

function asktry
    log "Command => `$BY$argv$RESET`"
    ask "Run?" || return 1
    eval "$argv" || { elog "Command failed! Exiting." && return 1 }
    return $status
end

function anim
    printf '\e[s' # Save cursor position 
    printf '\e[?25l' # Hide cursor
    printf '\e[2m' # Faint/dim text
    printf "$argv" # Print full string
    printf '\e[u' # Restore position
    for char in (string split '' "$argv")
        printf '\e[1m' # Enable bold
        printf "$char" # Print char
        sleep 0.03
        printf '\e[2D' # go back 2 columns
        printf '\e[22m' # Reset weight
        printf '\e[2m' # Faint/dim text
        printf "$last_char" # Print last char
        printf '\e[C' # Move forward
        printf '\e[22m' # Reset weight
        set last_char "$char" # Assign current char to last char
    end
    printf '\e[?25h' # Show cursor
end
