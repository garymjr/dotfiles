# Beads Issue Management

Use `@beads` subagent for planning and issue management.

## When to Use
- Complex multi-step tasks (>30 minutes)
- Breaking down features into manageable issues
- Managing dependencies between tasks
- Tracking progress on features/bugs

## Workflow
1. **Plan**: `@beads` to create issues and dependencies
2. **Check**: `bd ready` for unblocked work
3. **Work**: Update status to `in_progress`
4. **Complete**: Close issues with reasoning

## Key Commands
- `bd init` - Initialize in project
- `bd create "title"` - Create issue
- `bd ready` - Show unblocked work
- `bd dep add id1 id2` - Add dependency (id2 blocks id1)
- `bd close id` - Close issue

Always explain what beads commands you're running.