#!/bin/bash

case "$BLOCK_BUTTON" in
    1) dunstctl history-pop   ;;  # left click – show recent notifications
    3) dunstctl history-clear  ;;  # right click – clear history
esac


total=$(dunstctl history | wc -l)
printf ""
