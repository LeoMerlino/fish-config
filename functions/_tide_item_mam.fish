function _tide_item_mam
    function update
        curl -G 'https://lcm.lat/mam' -u leo:'h5ih3o5lyk464kl;k6##64' --silent > /tmp/mam
        echo \n"$(date +%H)" >> /tmp/mam
    end
    function query
        jq -r "$argv[1]" /tmp/mam 2>/dev/null
    end
    ! test -f /tmp/mam && update
    test (cat /tmp/mam | wc -l) -eq 1 && update && return 1
    test (date +%H) -ne (tail -1 /tmp/mam) && update
    set ratio (query '(.ratio * 100) / 100')
    set points (query '.seedbonus')
    set cheese (query '.wedges')
    echo -n "$BB $ratio$BGR - $BG󰫢 $points$BGR - $BY $cheese "
    functions -e update query
end
