#!/usr/bin/env bash

# Create screenshots folder if it doesn't exist
mkdir -p ~/Pictures/Screenshots

# Determine filename and take screenshot
if [ "$1" = "region" ]; then
    FILE=~/Pictures/Screenshots/region_$(date +%F_%T).png
    maim -u -s "$FILE"
    # Notification for region
    notify-send "📸 Regional screen captured" "Region saved to: $FILE"
else
    FILE=~/Pictures/Screenshots/full_$(date +%F_%T).png
    maim -u "$FILE"
    # Notification for full screen
    notify-send "📸 Screenshot Taken" "Full screen saved to: $FILE"
fi

# Copy the image to clipboard using CopyQ
copyq copy "image/png" - < "$FILE"
