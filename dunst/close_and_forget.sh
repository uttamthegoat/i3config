#!/usr/bin/env bash
# ~/.config/dunst/close_and_clear_debug.sh
# Close current dunst notification and clear history.
# Logs all output to /tmp/dunst-close.log for debugging.

LOG="/tmp/dunst-close.log"
{
  echo "===== dunst close script run: $(date) ====="
  echo "User: $(id -un)  UID: $(id -u)"
  echo "Initial PATH: $PATH"
  # Find dunstctl
  DCTL="$(command -v dunstctl 2>/dev/null || true)"
  if [ -z "$DCTL" ]; then
    for p in /usr/local/bin /usr/bin /bin /usr/local/sbin /usr/sbin /sbin; do
      [ -x "$p/dunstctl" ] && DCTL="$p/dunstctl" && break
    done
  fi
  echo "dunstctl resolved to: ${DCTL:-<not found>}"

  # Ensure DBUS_SESSION_BUS_ADDRESS is present; try to copy from dunst process if missing
  if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    echo "DBUS_SESSION_BUS_ADDRESS is empty in this environment."
    DUNST_PID="$(pgrep -u "$(id -un)" -x dunst | head -n1 || true)"
    echo "Detected dunst pid: ${DUNST_PID:-<none>}"
    if [ -n "$DUNST_PID" ] && [ -r "/proc/$DUNST_PID/environ" ]; then
      DBUS_ADDR="$(tr '\0' '\n' < /proc/$DUNST_PID/environ | sed -n 's/^DBUS_SESSION_BUS_ADDRESS=//p' | tail -n1 || true)"
      if [ -n "$DBUS_ADDR" ]; then
        export DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDR"
        echo "Exported DBUS_SESSION_BUS_ADDRESS from dunst process."
      else
        echo "Could not find DBUS_SESSION_BUS_ADDRESS in dunst process environ."
      fi
    else
      echo "dunst process not found or /proc/$DUNST_PID/environ unreadable."
    fi
  else
    echo "DBUS_SESSION_BUS_ADDRESS already set."
  fi
  echo "Effective DBUS_SESSION_BUS_ADDRESS: ${DBUS_SESSION_BUS_ADDRESS:-<none>}"

  if [ -z "$DCTL" ]; then
    echo "ERROR: dunstctl not found in PATH. Exiting."
    exit 1
  fi

  # Try to close current notification
  echo "Running: $DCTL close"
  if ! "$DCTL" close 2>&1; then
    echo "Warning: dunstctl close returned non-zero"
  else
    echo "dunstctl close succeeded"
  fi

  # small sleep to let dunst move notif into history if it does
  sleep 0.08

  # Attempt to clear history (this clears all history)
  echo "Running: $DCTL history-clear"
  if ! "$DCTL" history-clear 2>&1; then
    echo "Warning: dunstctl history-clear returned non-zero"
  else
    echo "dunstctl history-clear succeeded"
  fi

  echo "Script finished at $(date)"
} >> "$LOG" 2>&1
