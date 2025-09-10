#!/bin/bash
# Get current Nitrogen wallpaper
WALLPAPER=$(grep 'file=' ~/.config/nitrogen/lock-bg-saved.cfg | head -n1 | cut -d'=' -f2)

# Lock screen with Betterlockscreen
/usr/local/bin/betterlockscreen -u "$WALLPAPER" -l --blur 5 --color 333333ff
