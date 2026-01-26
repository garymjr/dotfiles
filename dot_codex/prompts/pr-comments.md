You are given a PR URL as $ARGUMENTS.

Use the gh CLI to fetch PR details and all comments (review comments and issue comments). Determine which comments must be addressed (bugs, regressions, correctness, tests, performance, security, API behavior) and which can be safely skipped (nit/style, already fixed, out of scope, subjective preference).

For skippable comments, draft a concise, polite response explaining why you’re skipping it (or noting it was already handled). For comments to address, list the action needed.

Output sections:
1) Must address: list comment URL + short action
2) Skippable: list comment URL + drafted reply

Use gh commands only; no web browsing. Quote exact error output if any command fails.
