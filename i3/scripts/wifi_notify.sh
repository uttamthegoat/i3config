#!/usr/bin/env bash

# Wait until connected at startup
while true; do
    ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
    if [ -n "$ssid" ]; then
        notify-send "📡 Wi-Fi Connected" "Connected to: $ssid"
        break
    fi
    sleep 2
done

# Now monitor for future events
nmcli monitor | while read -r line; do
    if echo "$line" | grep -q "connected"; then
        ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
        [ -n "$ssid" ] && notify-send "📡 Wi-Fi Connected" "Connected to: $ssid"
    fi
done
