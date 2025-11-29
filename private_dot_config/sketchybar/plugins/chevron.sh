#!/bin/sh

# Check if this is the initial setup or an update
if [ "$1" = "setup" ]; then
  # Chevron item setup
  sketchybar --add item chevron left \
             --set chevron icon= label.drawing=off
  exit 0
fi
