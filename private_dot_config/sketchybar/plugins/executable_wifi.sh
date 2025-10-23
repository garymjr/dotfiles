#!/bin/sh

# Set default icon immediately to ensure it shows on startup
sketchybar --set "$NAME" icon="󰤥" label=""

# Get WiFi information using system_profiler
WIFI_INFO=$(system_profiler SPAirPortDataType)
SSID=$(echo "$WIFI_INFO" | grep -A 5 "Current Network Information:" | grep -v "Current Network Information:" | grep -v "PHY Mode" | grep -v "Channel" | grep -v "Country Code" | grep -v "Network Type" | head -1 | sed 's/^[[:space:]]*//')

# Check if WiFi is connected
if [ -z "$SSID" ] || [ "$SSID" = "" ]; then
  sketchybar --set "$NAME" icon="󰖪" label=""
  exit 0
fi

# Default to medium signal since we can't get actual RSSI easily
RSSI="-65"

# Determine icon based on RSSI (signal strength)
# RSSI values: closer to 0 = stronger signal
if [ -n "$RSSI" ]; then
  if [ "$RSSI" -ge -50 ]; then
    ICON="󰤨"
  elif [ "$RSSI" -ge -60 ]; then
    ICON="󰤥"
  elif [ "$RSSI" -ge -70 ]; then
    ICON="󰤢"
  elif [ "$RSSI" -ge -80 ]; then
    ICON="󰤟"
  else
    ICON="󰤮"
  fi
else
  ICON="󰤫"
fi

# Truncate SSID if too long
if [ -n "$SSID" ] && [ ${#SSID} -gt 10 ]; then
  SSID=$(echo "$SSID" | cut -c1-10)...
fi

# Update SketchyBar item with just the icon
sketchybar --set "$NAME" icon="$ICON" label=""