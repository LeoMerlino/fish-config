function _tide_item_stats
    echo -n $BW"  $BY$(history |wc -l)"
    uptime | awk '{print $3}' | tr ':' '\n' | tr -d , | read -L h m
    echo -n $BW  $BC"up "{$h}h {$m}m
    uptime -r >/dev/null 2>&1 && {
        set load_avg (uptime -r|cut -d' ' -f4)
        set load (math "$load_avg / $(nproc) * 100")
        set colour "$(/opt/scripts/num_to_ansi "$load")"
        echo -en "$BW  $colour$load%"
    }
end
