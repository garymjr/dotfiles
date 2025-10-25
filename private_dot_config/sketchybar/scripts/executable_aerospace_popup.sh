#!/usr/bin/env bash

# This script generates popup items showing workspaces with open apps

CONFIG_DIR="${CONFIG_DIR:-.}"

# Get focused workspace
focused_ws=$(aerospace list-workspaces --focused 2>/dev/null)

# Get workspaces with windows, plus focused
workspaces=$(aerospace list-windows --all --format "%{workspace}" 2>/dev/null | sort -u)
if ! echo "$workspaces" | grep -q "^$focused_ws$"; then
  workspaces=$(printf "%s\n%s" "$focused_ws" "$workspaces" | sort -u)
fi

# Remove all previous popup items
sketchybar --query bar 2>/dev/null | jq -r '.items[]' 2>/dev/null | grep "^popup.aerospace_workspace\\." | while read -r item; do
  sketchybar --remove "$item" 2>/dev/null || true
done

# Process each workspace and create items
while IFS= read -r ws_name; do
  [ -z "$ws_name" ] && continue

  # Important: redirect stdin from /dev/null to prevent aerospace from consuming input
  app_list=$(aerospace list-windows --workspace "$ws_name" --format "%{app-name}" 2>/dev/null </dev/null | sort -u | tr '\n' ',' | sed 's/,$//' | sed 's/,/, /g')

  if [ -z "$app_list" ]; then
    app_list="(empty)"
  fi

  if [ "$ws_name" = "$focused_ws" ]; then
    label="[$ws_name] $app_list ✓"
  else
    label="[$ws_name] $app_list"
  fi

  # Escape quotes in label
  label_escaped="${label//\"/\\\"}"

  sketchybar --add item "popup.aerospace_workspace.$ws_name" "popup.aerospace_workspace" \
    --set "popup.aerospace_workspace.$ws_name" \
    label="$label_escaped" \
    icon="" \
    label.max_chars=60 \
    click_script="$CONFIG_DIR/scripts/aerospace_workspace_click.sh $ws_name"
done <<<"$workspaces"
