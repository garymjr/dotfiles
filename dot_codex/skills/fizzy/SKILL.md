---
name: fizzy
description: |
  Interact with Fizzy via the Fizzy CLI. Manage boards, cards, columns, comments,
  steps, reactions, tags, users, notifications, pins, uploads, search, auth, and board migration.
triggers:
  - fizzy
  - /fizzy
  - fizzy board
  - fizzy card
  - fizzy column
  - fizzy comment
  - fizzy step
  - fizzy reaction
  - fizzy tag
  - fizzy notification
  - link to fizzy
  - track in fizzy
  - create card
  - close card
  - move card
  - assign card
  - add comment
  - add step
  - search cards
  - search fizzy
  - find in fizzy
  - check fizzy
  - list fizzy
  - show fizzy
  - get from fizzy
  - what's in fizzy
  - what fizzy
  - how do I fizzy
  - my cards
  - my tasks
  - my board
  - assigned to me
  - pinned cards
  - fizzy.do
  - app.fizzy.do
invocable: true
argument-hint: "[action] [args...]"
---

# /fizzy - Fizzy Workflow Command

Use the `fizzy` CLI to work with Fizzy from the terminal.

This file is aligned to `fizzy version` v3.0.3. Verify with `fizzy --help` when behavior seems off.

## Agent Invariants

1. Cards use their `number` in CLI commands, not their `id`.
2. Other resources use their `id`.
3. Parse JSON with `jq` to keep output small.
4. Check `breadcrumbs` in responses for next actions with prefilled command values.
5. Check project board context in `.fizzy.yaml` or pass `--board` before listing cards.
6. Rich text fields accept HTML. Use `<p>` tags for paragraphs and `<action-text-attachment>` for inline images.
7. Card description is a string. Comment body is nested: `.body.plain_text` and `.body.html`.
8. Do not rely on commands absent from v3.0.3: `account`, `webhook`, `signup`, `doctor`, `board publish`, `board entropy`, `notification settings-*`, `user role`, `user avatar-remove`.

## Quick Start

```bash
fizzy auth status
fizzy identity show
fizzy board list | jq '[.data[] | {id, name}]'
fizzy card list --board BOARD_ID | jq '[.data[] | {number, title, closed, board: .board.name}]'
fizzy card show CARD_NUMBER | jq '.data | {number, title, description, steps}'
```

## Global Flags

All commands support:

| Flag | Description |
|---|---|
| `--account SLUG` | Account slug |
| `--api-url URL` | API base URL |
| `--pretty` | Pretty-print JSON output |
| `--token TOKEN` | API access token |
| `--verbose` | Show request/response details |
| `-h`, `--help` | Help |

No global `--json`, `--quiet`, `--styled`, `--markdown`, `--agent`, `--jq`, `--ids-only`, `--count`, or `--limit` flags are exposed in v3.0.3.

## Response Shape

Successful responses:

```json
{
  "success": true,
  "data": {},
  "breadcrumbs": [],
  "meta": {
    "timestamp": "2026-04-10T21:11:35Z"
  }
}
```

Error responses:

```json
{
  "success": false,
  "error": {
    "code": "ERROR",
    "message": "unknown command \"account\" for \"fizzy\""
  },
  "meta": {
    "timestamp": "2026-04-10T21:11:11Z"
  }
}
```

## Configuration And Auth

```bash
fizzy setup
fizzy auth login TOKEN
fizzy auth status
fizzy auth logout
fizzy identity show
```

Project config:

```yaml
account: account-slug
board: BOARD_ID
```

Priority is command flags, environment/config, then project defaults. Use `--account` for account selection.

## Pagination

List/search commands use:

```bash
--page N
--all
```

`--all` fetches all pages for the current filter. It does not include closed or postponed cards unless the filter asks for them.

Commands with pagination:

- `board list`
- `card list`
- `search`
- `comment list`
- `tag list`
- `user list`
- `notification list`

## Finding Content

```bash
fizzy card list --board BOARD_ID
fizzy search "query"
fizzy search "query" --board BOARD_ID
fizzy card list --assignee USER_ID
fizzy card list --unassigned --board BOARD_ID
fizzy card list --created today --sort newest
fizzy card list --indexed-by closed --closed thisweek
```

Common filters:

| Flag | Values |
|---|---|
| `--indexed-by` on cards | `all`, `closed`, `not_now`, `stalled`, `postponing_soon`, `golden` |
| `--indexed-by` on search | `all`, `closed`, `not_now`, `golden` |
| `--column` | Column ID or pseudo-column `not-yet`, `maybe`, `done` |
| `--sort` | `newest`, `oldest`, `latest` |
| `--created`, `--closed` | `today`, `yesterday`, `thisweek`, `lastweek`, `thismonth`, `lastmonth` |

## Boards

```bash
fizzy board list [--page N] [--all]
fizzy board show BOARD_ID
fizzy board create --name "Name" [--all_access true|false] [--auto_postpone_period N]
fizzy board update BOARD_ID [--name "Name"] [--all_access true|false] [--auto_postpone_period N]
fizzy board delete BOARD_ID
```

## Cards

```bash
fizzy card list [flags]
  --board BOARD_ID
  --column COLUMN_ID_OR_PSEUDO
  --assignee USER_ID
  --tag TAG_ID
  --indexed-by all|closed|not_now|stalled|postponing_soon|golden
  --search "terms"
  --sort newest|oldest|latest
  --creator USER_ID
  --closer USER_ID
  --unassigned
  --created PERIOD
  --closed PERIOD
  --page N
  --all

fizzy card show CARD_NUMBER
fizzy card create --board BOARD_ID --title "Title" [--description "HTML"] [--description_file PATH] [--image SIGNED_ID] [--tag-ids "id1,id2"] [--created-at TIMESTAMP]
fizzy card update CARD_NUMBER [--title "Title"] [--description "HTML"] [--description_file PATH] [--image SIGNED_ID] [--created-at TIMESTAMP]
fizzy card delete CARD_NUMBER
```

Status and workflow:

```bash
fizzy card close CARD_NUMBER
fizzy card reopen CARD_NUMBER
fizzy card postpone CARD_NUMBER
fizzy card untriage CARD_NUMBER
fizzy card column CARD_NUMBER --column COLUMN_ID_OR_PSEUDO
fizzy card move CARD_NUMBER --to BOARD_ID
```

Assignments, tags, watching, pins, and golden cards:

```bash
fizzy card assign CARD_NUMBER --user USER_ID
fizzy card self-assign CARD_NUMBER
fizzy card tag CARD_NUMBER --tag "name"
fizzy card watch CARD_NUMBER
fizzy card unwatch CARD_NUMBER
fizzy card pin CARD_NUMBER
fizzy card unpin CARD_NUMBER
fizzy card golden CARD_NUMBER
fizzy card ungolden CARD_NUMBER
fizzy card image-remove CARD_NUMBER
```

Attachments:

```bash
fizzy card attachments show CARD_NUMBER [--include-comments]
fizzy card attachments download CARD_NUMBER [ATTACHMENT_INDEX] [--include-comments] [-o OUTPUT]
```

## Columns

Boards have pseudo-columns: `not-yet`, `maybe`, `done`.

```bash
fizzy column list --board BOARD_ID
fizzy column show COLUMN_ID --board BOARD_ID
fizzy column create --board BOARD_ID --name "Name" [--color HEX]
fizzy column update COLUMN_ID --board BOARD_ID [--name "Name"] [--color HEX]
fizzy column delete COLUMN_ID --board BOARD_ID
```

## Comments

```bash
fizzy comment list --card CARD_NUMBER [--page N] [--all]
fizzy comment show COMMENT_ID --card CARD_NUMBER
fizzy comment create --card CARD_NUMBER --body "HTML" [--body_file PATH] [--created-at TIMESTAMP]
fizzy comment update COMMENT_ID --card CARD_NUMBER [--body "HTML"] [--body_file PATH]
fizzy comment delete COMMENT_ID --card CARD_NUMBER
fizzy comment attachments show --card CARD_NUMBER
fizzy comment attachments download --card CARD_NUMBER [ATTACHMENT_INDEX] [-o OUTPUT]
```

## Steps

```bash
fizzy step list --card CARD_NUMBER
fizzy step show STEP_ID --card CARD_NUMBER
fizzy step create --card CARD_NUMBER --content "Text" [--completed]
fizzy step update STEP_ID --card CARD_NUMBER [--content "Text"] [--completed] [--not_completed]
fizzy step delete STEP_ID --card CARD_NUMBER
```

## Reactions

```bash
fizzy reaction list --card CARD_NUMBER
fizzy reaction create --card CARD_NUMBER --content "emoji"
fizzy reaction delete REACTION_ID --card CARD_NUMBER

fizzy reaction list --card CARD_NUMBER --comment COMMENT_ID
fizzy reaction create --card CARD_NUMBER --comment COMMENT_ID --content "emoji"
fizzy reaction delete REACTION_ID --card CARD_NUMBER --comment COMMENT_ID
```

## Tags, Users, Pins, Notifications

```bash
fizzy tag list [--page N] [--all]

fizzy user list [--page N] [--all]
fizzy user show USER_ID
fizzy user update USER_ID [--name "Name"] [--avatar PATH]
fizzy user deactivate USER_ID

fizzy pin list

fizzy notification list [--page N] [--all]
fizzy notification tray [--include-read]
fizzy notification read NOTIFICATION_ID
fizzy notification unread NOTIFICATION_ID
fizzy notification read-all
```

## Search

Searches cards by text. Multiple words are AND terms.

```bash
fizzy search QUERY [--board BOARD_ID] [--assignee USER_ID] [--tag TAG_ID] [--indexed-by all|closed|not_now|golden] [--sort newest|oldest|latest] [--page N] [--all]
```

## Uploads

```bash
fizzy upload file PATH
```

Upload response fields:

| Field | Use |
|---|---|
| `signed_id` | Card header image via `--image` |
| `attachable_sgid` | Inline rich text image via `<action-text-attachment sgid="..."></action-text-attachment>` |

Use inline images by default. Use header images only when the user asks for a header/background.

## Board Migration

```bash
fizzy migrate board BOARD_ID --from SOURCE_SLUG --to TARGET_SLUG [--dry-run] [--include-images] [--include-comments] [--include-steps]
```

Migrates the board, columns, cards, timestamps, tags, and state. Optional flags migrate images, comments, and steps.

Not migrated exactly:

- Card numbers change.
- Card creators become the migrating user.
- Comment authors become the migrating user.
- User assignments must be redone.

## Common jq Patterns

```bash
fizzy card list --board BOARD_ID | jq '[.data[] | {number, title, closed, golden}]'
fizzy board list | jq '[.data[] | {id, name}]'
fizzy card show CARD_NUMBER | jq '.data | {number, title, description, steps}'
fizzy comment list --card CARD_NUMBER | jq '[.data[] | {id, body: .body.plain_text, creator: .creator.name}]'
fizzy tag list | jq '[.data[] | {id, title}]'
fizzy notification tray | jq '[.data[] | {id, read_at, subject}]'
```

## Resource Notes

Cards:

| Field | Note |
|---|---|
| `number` | Use for card CLI commands |
| `id` | Internal response ID |
| `description` | String |
| `description_html` | HTML with attachments |
| `closed` | Boolean |
| `steps` | Present in `card show`; do not assume in `card list` |

Comments:

| Field | Note |
|---|---|
| `id` | Use for comment CLI commands |
| `body.plain_text` | Plain text |
| `body.html` | HTML |

## Rich Text

```html
<p>First paragraph.</p>
<p><br></p>
<p>Second paragraph with spacing above.</p>
```

Each `attachable_sgid` can be used once. Upload again for another use.

## Troubleshooting

```bash
fizzy --help
fizzy COMMAND --help
fizzy auth status
fizzy identity show
fizzy version
```

Cards returning not found usually means the card number is wrong or the selected account is wrong. Use `--account SLUG` when switching accounts.
