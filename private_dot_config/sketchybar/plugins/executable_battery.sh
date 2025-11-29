#!/bin/sh

# Check if this is the initial setup or an update
if [ "$1" = "setup" ]; then
  # Battery item setup
  sketchybar --add item battery right \
             --set battery update_freq=120 script="$0" \
             --subscribe battery system_woke power_source_change
  exit 0
fi

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON=""; COLOR=0xffa6e3a1
  ;;
  [6-8][0-9]) ICON=""; COLOR=0xffa6e3a1
  ;;
  [3-5][0-9]) ICON=""; COLOR=0xfff9e2af
  ;;
  [1-2][0-9]) ICON=""; COLOR=0xfff38ba8
  ;;
  *) ICON=""; COLOR=0xfff38ba8
esac

if [[ "$CHARGING" != "" ]]; then
  ICON=""; COLOR=0xff89b4fa
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color="$COLOR"
