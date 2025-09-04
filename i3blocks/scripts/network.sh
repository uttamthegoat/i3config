#!/bin/bash
# Output the current Wi-Fi SSID or "Not Connected"
echo "$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2 || echo 'Not Connected')"
# Launch nmtui in kitty when clicked
[[ -z "${BLOCK_BUTTON}" ]] || (export DISPLAY=:0; kitty -e nmtui &)
