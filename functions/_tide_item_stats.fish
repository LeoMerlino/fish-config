function _tide_item_stats
    echo -n $BW"  $BY$(history |wc -l)"
    echo -n $BW"  $BC$(uptime -p)"
    echo -n $BW"  $BR$(load_avg=(uptime -r|cut -d' ' -f4) math "$load_avg / $(nproc) * 100")%"
end
