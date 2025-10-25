#!/usr/bin/env bash

# This script handles clicking on a workspace item in the popup
# It focuses the selected workspace

WORKSPACE_NAME="$1"

if [ -z "$WORKSPACE_NAME" ]; then
  echo "Error: Workspace name not provided"
  exit 1
fi

# Focus the selected workspace
aerospace workspace "$WORKSPACE_NAME" 2>/dev/null

# Close the popup
sketchybar --set aerospace_workspace popup.drawing=off 2>/dev/null || true
