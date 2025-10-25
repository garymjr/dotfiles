#!/usr/bin/env bash

# Toggle popup visibility
STATE=$(sketchybar --query item aerospace_workspace | jq -r ".popup.drawing")

if [ "$STATE" = "on" ]; then
  sketchybar --set aerospace_workspace popup.drawing=off
else
  # Close popup before regenerating items to avoid flickering
  sketchybar --set aerospace_workspace popup.drawing=off
  bash "$CONFIG_DIR/scripts/aerospace_popup.sh"
  # Open popup after items are ready
  sketchybar --set aerospace_workspace popup.drawing=on
fi
