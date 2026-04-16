---
name: atomic-commits
description: Split a large Git diff into safe, reviewable atomic commits by inventorying changed hunks, grouping them into coherent slices, staging only the selected patch for each slice, and committing incrementally without discarding unrelated work. Use when Codex is asked to break up a messy or oversized diff, separate refactors from behavior changes, prepare cleaner history for review, or create multiple commits from one working tree or staged diff.
---

# Atomic Commits

## Overview

Break one working tree diff into a sequence of focused commits without using interactive patch mode or throwing away user changes. Prefer staging synthetic patch slices into the index, committing one slice at a time, and re-inventorying after every commit.

Inputs:
- `repo`: target repository path, default `.`
- diff source: working tree, `--cached`, or `--base <rev>`
- any user preference about commit boundaries, message style, or ordering

When this skill references bundled files under `scripts/`, resolve them relative to the skill directory in `$CODEX_HOME` or `~/.codex`, not relative to the target repo.

## Workflow

### 1. Inspect the starting state

- Run `git -C <repo> status --short`.
- Check whether the repo is already mid-operation (`rebase`, `merge`, `cherry-pick`, `revert`, or conflicted state). If so, stop and explain the blocker.
- If there are already staged changes and the user did not explicitly say to split the staged diff, pause and clarify whether staged content is part of the plan.
- Treat unrelated user changes as immutable. Do not reset, restore, or stash them away unless the user explicitly asks.

### 2. Inventory the diff

Use the bundled script to list the current patch slices:

```bash
python "$CODEX_HOME/skills/atomic-commits/scripts/diff_slices.py" inventory --repo .
```

Common variants:

```bash
python "$CODEX_HOME/skills/atomic-commits/scripts/diff_slices.py" inventory --repo . --cached
python "$CODEX_HOME/skills/atomic-commits/scripts/diff_slices.py" inventory --repo . --base origin/main
```

The script prints one item per selectable slice:

- `H...`: a single text hunk inside a file
- `F...`: a whole-file item for untracked files, new or deleted files, binary changes, rename-only diffs, mode-only diffs, or any file diff without individual hunks

### 3. Plan the commit boundaries

Group slices by reason to change, not by raw file count.

Prefer these boundaries:

- keep production code and the tests that validate the same behavior together
- separate refactors from behavior changes
- separate broad formatting or mechanical edits from semantic changes
- keep generated files with the source change that requires them, unless the generated output is huge and easier to review separately
- keep pure renames or moves separate when they are logically independent

If multiple plausible groupings exist, show a short proposed commit plan before creating commits.

### 4. Stage one slice non-interactively

Emit a patch for the selected slice ids:

```bash
python "$CODEX_HOME/skills/atomic-commits/scripts/diff_slices.py" emit-patch --repo . --ids H001,H004 > /tmp/commit-1.patch
```

Preview the patch if the grouping is subtle:

```bash
sed -n '1,220p' /tmp/commit-1.patch
```

Stage only that patch:

```bash
git -C . apply --cached --binary /tmp/commit-1.patch
```

Then verify what is staged:

```bash
git -C . diff --cached --stat
git -C . diff --cached
```

If the patch does not apply cleanly, regenerate the inventory from the current diff and build a fresh patch. Do not keep reusing stale ids after the working tree changes.

### 5. Verify and commit

- Run the lightest meaningful verification for the staged slice.
- Write a commit message that describes one unit of intent.
- Commit the staged slice.
- Re-run the inventory against the remaining diff. The ids will change after each commit; always use the newest inventory before creating the next patch.

Repeat until the remaining diff is empty or until the user asks to stop.

## Commit-Shaping Heuristics

- One commit should answer one review question.
- If a reviewer would want to revert part of the change independently, it probably wants its own commit.
- If two hunks only make sense together to keep the repo building or tests passing, keep them together.
- Avoid mixing migrations, API changes, cleanup, and test rewrites unless they are inseparable.
- Prefer a slightly larger coherent commit over a tiny commit that leaves the tree broken.

## Safety Rules

- Prefer `git apply --cached` over `git add -p`.
- Never use destructive cleanup commands such as `git reset --hard`, `git checkout --`, or `git restore` on user changes unless explicitly asked.
- Never rewrite existing commits unless the user explicitly requests history editing.
- When splitting changes inside the same file, commit one hunk group at a time and re-run `inventory` after each commit.

## Example Requests

- "Use $atomic-commits to break this branch into reviewable commits."
- "Split my staged diff into atomic commits and keep refactors separate from feature work."
- "Take this messy git diff and turn it into a clean commit stack without losing the remaining changes."
