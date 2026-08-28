function _tide_item_stats
    echo -n $BW"  $BY$(history |wc -l)"
    uptime | awk '{print $3}' | tr ':' '\n' | tr -d , | read -L h m
    echo -n $BW  $BC"up "{$h}h {$m}m
    set load (load_avg=(uptime -r|cut -d' ' -f4) math "$load_avg / $(nproc) * 100")
    set colour "$(/opt/scripts/num_to_ansi "$load")"
    echo -en "$BW  $colour$load%"
end
