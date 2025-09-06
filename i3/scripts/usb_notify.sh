#!/usr/bin/env bash

# Monitor USB events
udevadm monitor --subsystem-match=usb --udev | while read -r line; do
    if echo "$line" | grep -q "add"; then
        # Get the sysfs path of the last added USB device
        read -r devline
        if [[ "$devline" =~ /devices.* ]]; then
            sysfs_path="${BASH_REMATCH[0]}"
            # Get human-readable name
            dev_name=$(udevadm info -q property -p "$sysfs_path" | grep 'ID_MODEL=' | cut -d= -f2)
            [ -z "$dev_name" ] && dev_name="Unknown USB Device"
            notify-send "🔌 USB Connected" "$dev_name"
        fi
    fi
done
