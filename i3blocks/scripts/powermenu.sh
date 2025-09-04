#!/usr/bin/env bash

# Always output the power icon (for i3blocks panel)
echo "⏻"

# Handle clicks
if [ "$BLOCK_BUTTON" = "1" ]; then

    # Define the options for the rofi menu
    options="Shutdown\nReboot\nLock\nLogout\nSleep"

    # Display rofi menu and capture the selected option
    selected=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -i -theme ~/.config/rofi/powermenu.rasi)

    # Execute the corresponding command based on selection
    case "$selected" in
        "Shutdown")
            systemctl poweroff
            ;;
        "Reboot")
            systemctl reboot
            ;;
        "Lock")
            i3lock -c 000000  # Assumes i3lock is installed
            ;;
        "Logout")
            i3-msg exit
            ;;
        "Sleep")
            systemctl suspend
            ;;
    esac
fi
