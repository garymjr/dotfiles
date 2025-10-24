#!/usr/bin/env bash

# Get current focused workspace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

ICON=""

sketchybar --set $NAME label="$FOCUSED_WORKSPACE" icon="$ICON"
