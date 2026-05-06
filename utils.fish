source /home/$USER/.config/fish/colours.fish

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
