#!/usr/bin/env bash

sketchybar --add event aerospace_workspace_change

sketchybar --add item aerospace_workspace left \
  --subscribe aerospace_workspace aerospace_workspace_change \
  --set aerospace_workspace \
  background.drawing=off \
  label.highlight_color="" \
  icon="" \
  label="" \
  script="$CONFIG_DIR/scripts/aerospace.sh" \
  click_script='bash "$CONFIG_DIR/scripts/aerospace_popup_toggle.sh"'

sketchybar --set aerospace_workspace \
  popup.drawing=off \
  popup.blur_radius=20 \
  popup.background.color=0xdd1e1e2e \
  popup.background.border_color=0xff89b4fa \
  popup.background.border_width=2 \
  popup.background.corner_radius=8 \
  popup.background.padding_left=0 \
  popup.background.padding_right=0 \
  popup.background.padding_top=0 \
  popup.background.padding_bottom=0 \
  popup.y_offset=5 \
  popup.align=left
