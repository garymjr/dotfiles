---
name: gmail
description: Manage Gmail emails - list, read, archive, trash, and label emails using the Gmail API. Use when user asks to check emails, read messages, organize inbox, or manage email labels.
---

# Gmail Skill

Manage Gmail emails using the Gmail API. This skill provides commands to list, read, archive, trash, and label emails.

## Prerequisites

- Node.js must be installed
- `googleapis` package (installed via npm below)

## Setup

### 1. Install Dependencies

```bash
cd ~/.config/zigbot/skills/gmail
npm install googleapis
```

### 2. Enable APIs in Google Cloud

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable **both** the Gmail API and Google Calendar API
4. Go to Credentials → Create Credentials → OAuth 2.0 Client ID
5. Download the JSON credentials file
6. Save as `~/.config/zigbot/google/credentials.json`

> **Note:** Gmail and Calendar share the same credentials and tokens. Place them in the shared `~/.config/zigbot/google/` directory.

### 3. Authenticate

First time setup requires OAuth consent (this grants access to both Gmail and Calendar):

```bash
node ~/.config/zigbot/skills/gmail/scripts/gmail.js auth
```

This will open a browser for authentication. Tokens are saved to `~/.config/zigbot/google/token.json` and will work for both Gmail and Calendar.

## Usage

### List Emails

```bash
node ~/.config/zigbot/skills/gmail/scripts/gmail.js list --max 20 --query "is:unread"
```

Options:
- `--max N` or `-m N`: Maximum results (default: 10)
- `--query` or `-q`: Gmail search query (default: "is:inbox")

### Read Email

```bash
node ~/.config/zigbot/skills/gmail/scripts/gmail.js read <message_id>
```

Get message_id from the list command output.

### Archive Email

```bash
node ~/.config/zigbot/skills/gmail/scripts/gmail.js archive <message_id>
```

Moves email to All Mail (removes from Inbox).

### Trash Email

```bash
node ~/.config/zigbot/skills/gmail/scripts/gmail.js trash <message_id>
```

Moves email to Trash.

### Label Email

```bash
node ~/.config/zigbot/skills/gmail/scripts/gmail.js label <message_id> <label_name>
```

Creates label if it doesn't exist. Examples:
```bash
node ~/.config/zigbot/skills/gmail/scripts/gmail.js label <id> "Work"
node ~/.config/zigbot/skills/gmail/scripts/gmail.js label <id> "Important"
```

### List Labels

```bash
node ~/.config/zigbot/skills/gmail/scripts/gmail.js labels
```

Shows all available labels in your Gmail account.

## Convenience Alias

Add to your shell profile (`~/.zshrc` or `~/.bashrc`) for easier access:

```bash
gmail() {
  node ~/.config/zigbot/skills/gmail/scripts/gmail.js "$@"
}
```

Then use: `gmail list`, `gmail read <id>`, etc.

## Notes

- Message IDs are long alphanumeric strings from `gmail list`
- Archived emails still appear in search results with `is:all`
- Trashed emails are permanently deleted after 30 days
- Labels are created automatically if they don't exist
