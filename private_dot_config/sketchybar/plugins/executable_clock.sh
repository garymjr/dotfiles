#!/bin/sh

# Check if this is the initial setup or an update
if [ "$1" = "setup" ]; then
  # Clock item setup
  sketchybar --add item clock right \
             --set clock update_freq=10 icon= script="$0" icon.color=0xfffab387
  exit 0
fi

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

sketchybar --set "$NAME" label="$(date '+%m/%d %H:%M')" icon.color=0xfffab387
