---
name: herdr
description: Control herdr from inside a herdr-managed pane. Use when running inside herdr (`HERDR_ENV=1`) to inspect workspaces, tabs, and panes; split panes; run commands in sibling panes; coordinate agents; read pane output; or wait for output/status changes through the `herdr` CLI.
---

# herdr

Before using `herdr`, check that `HERDR_ENV=1`. If it is not set to `1`, say you are not running inside a herdr-managed pane and stop.

Do not inspect or control the focused herdr pane from outside herdr. Use current ids from `workspace list`, `tab list`, `pane list`, or create/split responses before acting; ids can compact after workspaces, tabs, or panes close.

## Concepts

- Workspaces are project contexts. Each workspace has one or more tabs.
- Tabs are subcontexts inside a workspace. Each tab has one or more panes.
- Panes are terminal splits. Each pane runs a shell, agent, server, test, log stream, or other process.
- `agent_status` can be `idle`, `working`, `blocked`, `done`, or `unknown`; `done` means the agent finished but the pane has not been viewed yet.
- Workspace ids look like `1`; tab ids look like `1:1`; pane ids look like `1-1`.

## Discover State

List panes and identify your focused pane:

```bash
herdr pane list
```

List workspaces:

```bash
herdr workspace list
```

List tabs in a workspace:

```bash
herdr tab list --workspace 1
```

## Read Panes

Read another pane's current or recent output:

```bash
herdr pane read 1-1 --source visible --lines 50
herdr pane read 1-1 --source recent --lines 50
herdr pane read 1-1 --source recent-unwrapped --lines 50
```

Use `recent-unwrapped` when matching or inspecting text that may have soft-wrapped in the terminal. `pane read` prints text, not JSON. Add `--format ansi` or `--ansi` for rendered ANSI snapshots.

## Split And Run

Split a pane without moving focus, parse the new pane id, then run a command there:

```bash
NEW_PANE=$(herdr pane split 1-2 --direction right --no-focus | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
herdr pane run "$NEW_PANE" "npm run dev"
```

Use `--direction down` for a horizontal split. `pane run` sends text and Enter; `pane send-text` sends text without Enter; `pane send-keys` sends keys such as `Enter`.

## Wait

Wait for output:

```bash
herdr wait output 1-3 --match "ready on port 3000" --timeout 30000
herdr wait output 1-3 --match "server.*ready" --regex --timeout 30000
```

Wait for another agent:

```bash
herdr wait agent-status 1-1 --status done --timeout 120000
herdr pane read 1-1 --source recent --lines 100
```

If `wait output` times out, it exits with code `1`. Use `pane read` for output that already exists; use `wait output` for future output.

## Tabs And Workspaces

```bash
herdr tab create --workspace 1 --label "logs"
herdr tab focus 1:2
herdr tab rename 1:2 "logs"
herdr tab close 1:2

herdr workspace create --cwd /path/to/project --label "api server"
herdr workspace focus 2
herdr workspace rename 1 "api server"
herdr workspace close 2
```

Use `--no-focus` on `workspace create`, `tab create`, and `pane split` when the current pane should stay focused.

## JSON Responses

`workspace list`, `workspace create`, `tab list`, `tab create`, `tab get`, `tab focus`, `tab rename`, `tab close`, `pane list`, `pane get`, `pane split`, `wait output`, and `wait agent-status` print JSON on success.

Useful response paths:

- `workspace create`: `result.workspace`, `result.tab`, `result.root_pane`
- `tab create`: `result.tab`, `result.root_pane`
- `pane split`: `result.pane.pane_id`
