---
name: github
description: Interact with GitHub using the `gh` CLI. Use `gh issue`, `gh pr`, `gh run`, and `gh api` for issues, PRs, CI runs, and advanced queries.
---

# GitHub Skill

Interact with GitHub using the official `gh` CLI tool. This skill provides commands for managing issues, pull requests, workflows, and more.

## Prerequisites

- `gh` CLI must be installed
- GitHub CLI authentication configured

### Install gh CLI

```bash
# macOS
brew install gh

# Linux
sudo apt install gh

# Or download from: https://github.com/cli/cli
```

### Authenticate

```bash
gh auth login
```

This will open a browser for GitHub authentication. Follow the prompts to complete setup.

## Common Commands

### Issues

```bash
# List issues in a repository
gh issue list

# List issues with specific labels
gh issue list --label "bug"

# View a specific issue
gh issue view <issue-number>

# Create a new issue
gh issue create --title "Issue Title" --body "Issue description"

# Close an issue
gh issue close <issue-number>
```

### Pull Requests

```bash
# List pull requests
gh pr list

# List open PRs
gh pr list --state open

# View a specific PR
gh pr view <pr-number>

# Check out a PR locally
gh pr checkout <pr-number>

# Create a new PR
gh pr create --title "PR Title" --body "PR description" --base main

# View PR diff
gh pr diff <pr-number>

# Review a PR
gh pr review <pr-number> --approve  # or --request-changes
```

### Workflows / Actions

```bash
# List recent workflow runs
gh run list

# View run status
gh run view <run-id>

# Rerun a workflow
gh run rerun <run-id>

# Download workflow run artifacts
gh run download <run-id>
```

### Repository Info

```bash
# View repository information
gh repo view

# View repository issues summary
gh repo view --json issues

# List branches
gh repo view --json branch
```

### Using gh api (Advanced)

For more complex queries, use the GitHub API directly:

```bash
# Get repository information
gh api repos/<owner>/<repo>

# Search issues
gh api search/issues?q=repo:<owner>/<repo>+is:issue+label:bug

# Get pull requests
gh api repos/<owner>/<repo>/pulls

# Get workflow runs
gh api repos/<owner>/<repo>/actions/runs

# Paginate through results
gh api repos/<owner>/<repo>/issues?per_page=100
```

### Working with GitHub CLI in Current Repository

When inside a GitHub repository, many commands automatically use the current repo:

```bash
# These work in any git repo that has a remote pointing to GitHub
gh issue list
gh pr list
gh run list
```

## Convenience Alias

Add to your shell profile (`~/.zshrc` or `~/.bashrc`) for easier access:

```bash
alias ghpr='gh pr'
alias ghissue='gh issue'
alias ghrun='gh run'
```

## Notes

- Use `gh --help` for full command documentation
- Set `GH_REPO` environment variable to override the default repository
- Use `--jq` flag to filter JSON output: `gh issue list --jq '.[].title'`
- Use `--json` flag for machine-readable output: `gh repo view --json name,description`
