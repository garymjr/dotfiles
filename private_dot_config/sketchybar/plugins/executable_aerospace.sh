#!/usr/bin/env bash

# Check if this is the initial setup or an update
if [ "$1" = "setup" ]; then
  sketchybar --add event aerospace_workspace_change

  # Create 5 workspace items
  for i in {1..5}; do
    sketchybar --add item "aerospace_ws_$i" left \
      --subscribe "aerospace_ws_$i" aerospace_workspace_change \
      --set "aerospace_ws_$i" \
      background.drawing=off \
      label.color=0xff6c7086 \
      label.font="SF Pro:Bold:14.0" \
      label="$i" \
      icon="" \
      script="$0" \
      click_script="$0 click $i"
  done

  # Trigger initial color update
  bash "$0"
  exit 0
fi

# Handle click events
if [ "$1" = "click" ]; then
  WORKSPACE_NAME="$2"
  if [ -z "$WORKSPACE_NAME" ]; then
    echo "Error: Workspace name not provided"
    exit 1
  fi
  # Focus the selected workspace
  aerospace workspace "$WORKSPACE_NAME" 2>/dev/null
  exit 0
fi

# Get current focused workspace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

# Update all 5 workspace items
for i in {1..5}; do
  if [ "$i" = "$FOCUSED_WORKSPACE" ]; then
    # Active workspace - rosewater color
    sketchybar --set "aerospace_ws_$i" label.color=0xfff5e0dc
  else
    # Inactive workspace - overlay0 color
    sketchybar --set "aerospace_ws_$i" label.color=0xff6c7086
  fi
done