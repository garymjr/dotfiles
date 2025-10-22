#!/usr/bin/env bash

# Function to get icon for workspace
get_workspace_icon() {
  case "$1" in
  1) echo "" ;;
  2) echo "" ;;
  *) echo "" ;; # Default empty icon
  esac
}

ICON=$(get_workspace_icon "$1")

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME label.color="0x44ffffff" icon.color="0x44ffffff" icon="$ICON"
else
  sketchybar --set $NAME label.color="0xffffffff" icon.color="0xffffffff" icon="$ICON"
fi
