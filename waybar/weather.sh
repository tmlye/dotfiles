#!/bin/bash
# Usage: weather.sh <location>. Prints waybar JSON.

location=$1
cache=~/.cache/waybar-weather-$location.json

age() { echo $(($(date +%s) - $(stat -c %Y "$cache" 2>/dev/null || echo 0))); }

if [ "$(age)" -gt 1740 ]; then
    data=$(curl -sf --max-time 10 "https://wttr.in/$location?format=j1" |
        jq -ce '.current_condition[0] | select(.weatherCode) | {code: .weatherCode, temp: .temp_C, feels: .FeelsLikeC, desc: .weatherDesc[0].value}' 2>/dev/null) &&
        printf '%s\n' "$data" >"$cache.tmp" && mv "$cache.tmp" "$cache"
fi

# Hide the module rather than show weather older than 3 hours.
[ "$(age)" -gt 10800 ] && exit 0

# WWO weather codes to Nerd Font Material Design icons. Pango cannot render the WOFF2 Font Awesome.
jq -c --arg loc "$location" '
    def icon: {
        "113": "f0599", "116": "f0595", "119": "f0590", "122": "f0590",
        "143": "f0591", "248": "f0591", "260": "f0591",
        "176": "f0f33", "263": "f0f33", "293": "f0f33", "353": "f0f33",
        "266": "f0597", "296": "f0597", "299": "f0597", "302": "f0597",
        "305": "f0596", "308": "f0596", "356": "f0596", "359": "f0596",
        "182": "f067f", "185": "f067f", "281": "f067f", "284": "f067f", "311": "f067f",
        "314": "f067f", "317": "f067f", "320": "f067f", "362": "f067f", "365": "f067f",
        "350": "f0592", "374": "f0592", "377": "f0592",
        "179": "f0598", "227": "f0598", "323": "f0598", "326": "f0598", "368": "f0598",
        "230": "f0f36", "329": "f0f36", "332": "f0f36", "335": "f0f36", "338": "f0f36", "371": "f0f36",
        "200": "f0593", "386": "f067e", "389": "f067e", "392": "f067e", "395": "f067e"
    }[.code] // "f02d7";
    def signed: if test("^-") or . == "0" then . else "+" + . end;
    ((.temp | signed) + (if .feels == .temp then "" else "(\(.feels))" end) + " °C") as $t
    | {
        text: "<span font_family=\"DejaVuSansM Nerd Font Propo\" size=\"large\">&#x\(icon);</span> \($t)",
        alt: $loc,
        tooltip: "\($loc): \($t) \(.desc)"
    }' "$cache"
