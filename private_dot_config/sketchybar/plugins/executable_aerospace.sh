#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change

sketchybar --add item aerospace_workspace left \
  --subscribe aerospace_workspace aerospace_workspace_change \
  --set aerospace_workspace \
  background.drawing=off \
  label.highlight_color="" \
  icon="" \
  label="" \
  script="$CONFIG_DIR/scripts/aerospace.sh"
