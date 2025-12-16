---
description: Get next ready beads issue and start working on it
---

# Get next ready beads issue and start working on it

---

## Input: $ARGUMENTS

If input is provided, use the first argument as the issue ID. Otherwise, use the beads_ready tool to get issues ready to work on and select the first one. Claim the selected issue by updating its status to in_progress using beads_update_status. Then, show the issue details using beads_show, create a plan for the issue, add the plan to the bead using beads_add_note, create dependent beads if needed using beads_create and beads_add_dependency, and wait for approval before proceeding.
