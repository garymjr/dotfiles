#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change

for sid in {1..5}; do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    background.drawing=off \
    label.highlight_color="" \
    icon="" \
    label="$sid" \
    click_script="aerospace workspace $sid" \
    script="$CONFIG_DIR/scripts/aerospace.sh $sid"
done
