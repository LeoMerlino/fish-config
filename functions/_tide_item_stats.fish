function _tide_item_stats
    echo -n $BW"  $BY$(history |wc -l)"
    bash -c 'read -r uptime_secs _ < /proc/uptime
    uptime_secs=${uptime_secs%.*}
    h=$((uptime_secs / 3600))
    m=$(((uptime_secs % 3600) / 60))
    echo "$h $m"' | read h m
    echo -n $BW  $BC"up "{$h}h {$m}m
    set load_avg (string split ' ' -- (cat /proc/loadavg))[1]
    set load (math "$load_avg / $(nproc) * 100")
    test -f /opt/scripts/num_to_ansi && set colour "$(/opt/scripts/num_to_ansi "$load")"
    echo -en "$BW  $colour$load%"
end
