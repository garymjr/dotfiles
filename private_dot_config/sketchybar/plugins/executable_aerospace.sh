#!/usr/bin/env bash

# Function to get icon for workspace
get_workspace_icon() {
  case "$1" in
  1) echo "" ;;
  *) echo "" ;; # Default empty icon
  esac
}

for sid in $(aerospace list-windows --all --format '%{workspace}'); do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    background.drawing=off \
    label.highlight_color="" \
    icon="$(get_workspace_icon $sid)" \
    label="$sid" \
    click_script="aerospace workspace $sid" \
    script="$CONFIG_DIR/plugins/aerospace.sh $sid"
done

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME label.color="0x44ffffff" icon.color="0x44ffffff"
else
  sketchybar --set $NAME label.color="0xffffffff" icon.color="0xffffffff"
fi
