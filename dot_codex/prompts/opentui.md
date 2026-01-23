Load the OpenTUI TUI framework skill and help with any terminal user interface development task.

## Workflow

### Step 1: Load opentui skill

### Step 2: Identify task type from user request

Analyze $ARGUMENTS to determine:

- **Framework needed** (Core imperative, React declarative, Solid declarative)
- **Task type** (new project setup, component implementation, layout, keyboard handling, debugging, testing)

Use decision trees in SKILL.md to select correct reference files.

### Step 3: Read relevant reference files

Based on task type, read from `references/<area>/`:

| Task | Files to Read |
|------|---------------|
| New project setup | `<framework>/README.md` + `<framework>/configuration.md` |
| Implement components | `<framework>/api.md` + `components/<category>.md` |
| Layout/positioning | `layout/README.md` + `layout/patterns.md` |
| Handle keyboard input | `keyboard/README.md` |
| Add animations | `animation/README.md` |
| Debug/troubleshoot | `<framework>/gotchas.md` + `testing/README.md` |
| Write tests | `testing/README.md` |
| Understand patterns | `<framework>/patterns.md` |

### Step 4: Execute task

Apply OpenTUI-specific patterns and APIs from references to complete the user's request.

### Step 5: Summarize

```
=== OpenTUI Task Complete ===

Framework: <core | react | solid>
Files referenced: <reference files consulted>

<brief summary of what was done>
```

<user-request>
$ARGUMENTS
</user-request>
