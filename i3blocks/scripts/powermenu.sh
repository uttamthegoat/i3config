#!/usr/bin/env bash

show_powermenu() {
    options="Shutdown\nReboot\nLock\nLogout\nSleep"

    selected=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -i -theme ~/.config/rofi/powermenu.rasi)

    case "$selected" in
        "Shutdown") systemctl poweroff ;;
        "Reboot") systemctl reboot ;;
        "Lock") i3lock -c 000000 ;;
        "Logout") i3-msg exit ;;
        "Sleep") systemctl suspend ;;
    esac
}

# Always output the power icon for i3blocks
echo "⏻"

# If clicked from i3blocks
if [ "$BLOCK_BUTTON" = "1" ]; then
    show_powermenu
fi

# If script is called with argument "launch" (for keybinding)
if [ "$1" = "launch" ]; then
    show_powermenu
fi
