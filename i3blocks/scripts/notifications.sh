#!/bin/bash

# Display count
if [ "$BLOCK_BUTTON" = "1" ]; then  # Left-click
  dunstctl history-pop  # Pop and show recent notifications
fi

echo "$(dunstctl count waiting)"
