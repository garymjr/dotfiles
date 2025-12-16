---
description: Get next ready beads issue and start working on it
---

# Get next ready beads issue and start working on it

---

## Input: $ARGUMENTS

If input is provided, use the first argument as the issue ID. Otherwise, use the beads_ready tool to get issues ready to work on and select the first one. Claim the selected issue by updating its status to in_progress using beads_update_status. Then, show the issue details using beads_show, create a detailed plan for the issue, and update the bead's description with the plan using beads_update. Create dependent beads if needed using beads_create and beads_add_dependency, and wait for approval before proceeding.
