---
name: calendar
description: Manage Google Calendar events - list, create, read, update, and delete events. Use when user asks to check calendar, schedule meetings, or manage events.
---

# Google Calendar Skill

Manage Google Calendar events using the Calendar API. This skill provides commands to list, create, read, update, and delete events.

## Prerequisites

- Node.js must be installed
- `googleapis` package (installed via npm below)

## Setup

### 1. Install Dependencies

```bash
cd ~/.config/zigbot/skills/calendar
npm install googleapis
```

### 2. Enable Calendar API in Google Cloud

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable **both** the Google Calendar API and Gmail API
4. Go to Credentials → Create Credentials → OAuth 2.0 Client ID
5. Download the JSON credentials file
6. Save as `~/.config/zigbot/google/credentials.json`

> **Note:** Calendar and Gmail share the same credentials and tokens. Place them in the shared `~/.config/zigbot/google/` directory.

### 3. Authenticate

First time setup requires OAuth consent (this grants access to both Calendar and Gmail):

```bash
node ~/.config/zigbot/skills/calendar/scripts/calendar.js auth
```

This will open a browser for authentication. Tokens are saved to `~/.config/zigbot/google/token.json` and will work for both Gmail and Calendar.

## Usage

### Authenticate

```bash
node ~/.config/zigbot/skills/calendar/scripts/calendar.js auth
```

### List Events

```bash
node ~/.config/zigbot/skills/calendar/scripts/calendar.js list --days 7
```

Options:
- `--days N` or `-d N`: Number of days to look ahead (default: 7)
- `--cal <id>` or `-c <id>`: Calendar ID (default: "primary")

### Create Event

```bash
node ~/.config/zigbot/skills/calendar/scripts/calendar.js create "Meeting Title" "2026-02-15T14:00:00" "2026-02-15T15:00:00"
```

Arguments:
1. Event title
2. Start time (ISO 8601 format)
3. End time (ISO 8601 format)

Optional flags:
- `--description "desc"` or `-m "desc"`: Event description
- `--location "loc"` or `-l "loc"`: Location
- `--cal <id>` or `-c <id>`: Calendar ID (default: "primary")

### Read Event

```bash
node ~/.config/zigbot/skills/calendar/scripts/calendar.js read <event_id>
```

Get event_id from the list command output.

### Update Event

```bash
node ~/.config/zigbot/skills/calendar/scripts/calendar.js update <event_id> "New Title"
```

Arguments:
1. Event ID
2. New title (optional - leave empty to keep existing)

Optional flags:
- `--start "datetime"` - New start time
- `--end "datetime"` - New end time
- `--description "desc"` or `-m "desc"`: New description
- `--location "loc"` or `-l "loc"`: New location

### Delete Event

```bash
node ~/.config/zigbot/skills/calendar/scripts/calendar.js delete <event_id>
```

### List Calendars

```bash
node ~/.config/zigbot/skills/calendar/scripts/calendar.js calendars
```

Shows all available calendars.

## Convenience Alias

Add to your shell profile (`~/.zshrc` or `~/.bashrc`) for easier access:

```bash
gcal() {
  node ~/.config/zigbot/skills/calendar/scripts/calendar.js "$@"
}
```

Then use: `gcal list`, `gcal read <id>`, `gcal create "Title" "start" "end"`, etc.

## Notes

- Event IDs are long alphanumeric strings from `gcal list`
- DateTime format must be ISO 8601 (e.g., "2026-02-15T14:00:00")
- Use quotes around datetime values to preserve the T character
- The "primary" calendar is your default Google Calendar
