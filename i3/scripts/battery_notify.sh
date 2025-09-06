#!/bin/bash

# Set DBus for cron environment
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    if [ -f ~/.dbus-session-address ]; then
        export DBUS_SESSION_BUS_ADDRESS=$(cat ~/.dbus-session-address)
    else
        export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
    fi
fi

# Optional: Also set DISPLAY if needed (for some setups)
export DISPLAY=:0

BATTERY=/sys/class/power_supply/BAT0  # Adjust if your battery is BAT1, etc.
LOW_THRESHOLD=15  # Alert below 15% when discharging
FULL_THRESHOLD=99  # Alert at or above 99% when charging/full

# Function to send a notification and create a lockfile to avoid repeats
send_notification() {
    local type=$1
    local message=$2
    local lockfile="/tmp/battery_$type"

    if [ ! -f "$lockfile" ]; then
        notify-send -u critical "Battery Alert" "$message"
        touch "$lockfile"
        echo "Notification sent: $message" >> /tmp/battery_debug.log
    else
        echo "Notification skipped due to lockfile: $message" >> /tmp/battery_debug.log
    fi
}

# Function to clear lockfile if condition no longer applies
clear_lockfile() {
    local type=$1
    local lockfile="/tmp/battery_$type"
    if [ -f "$lockfile" ]; then
        rm "$lockfile"
        echo "Lockfile cleared: $lockfile" >> /tmp/battery_debug.log
    fi
}

# Get current capacity and status (with error handling)
capacity=$(cat "$BATTERY/capacity" 2>/dev/null)
status=$(cat "$BATTERY/status" 2>/dev/null)

if [ -z "$capacity" ] || [ -z "$status" ]; then
    echo "Failed to read battery capacity or status (check path: $BATTERY)" >> /tmp/battery_debug.log
    exit 1
fi

echo "Capacity: $capacity, Status: $status" >> /tmp/battery_debug.log

if [ "$status" = "Discharging" ]; then
    clear_lockfile "full"
    if [ "$capacity" -le "$LOW_THRESHOLD" ]; then
        send_notification "low" "Battery Low: $capacity% - Plug in soon!"
    else
        clear_lockfile "low"
        echo "Not low: Capacity $capacity > $LOW_THRESHOLD" >> /tmp/battery_debug.log
    fi
elif [ "$status" = "Charging" ]; then
    clear_lockfile "low"
    if [ "$capacity" -ge "$FULL_THRESHOLD" ]; then
        send_notification "full" "Battery Fully Charged: $capacity% - You can unplug now."
    else
        clear_lockfile "full"
        echo "Not full: Capacity $capacity < $FULL_THRESHOLD" >> /tmp/battery_debug.log
    fi
elif [ "$status" = "Full" ]; then
    clear_lockfile "low"  # Clear low since it's full
    if [ "$capacity" -ge "$FULL_THRESHOLD" ]; then
        send_notification "full" "Battery Fully Charged: $capacity% - You can unplug now."
    else
        clear_lockfile "full"
        echo "Full status but capacity $capacity < $FULL_THRESHOLD" >> /tmp/battery_debug.log
    fi
else
    clear_lockfile "low"
    clear_lockfile "full"
    echo "Unknown battery status: $status" >> /tmp/battery_debug.log
fi
