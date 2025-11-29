#!/bin/sh

# Check if this is the initial setup or an update
if [ "$1" = "setup" ]; then
  # Front app item setup
  sketchybar --add item front_app left \
             --set front_app icon.drawing=off script="$0" \
             --subscribe front_app front_app_switched
  exit 0
fi

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO"
fi
