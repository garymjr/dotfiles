#!/usr/bin/env python3
import argparse
import json
import subprocess
import sys
from dataclasses import dataclass
from typing import List


LABEL = "ready to merge"


@dataclass
class PullRequest:
    number: int
    title: str
    url: str
    head_ref: str
    base_ref: str
    head_repo: str
    is_cross_repo: bool


def run(cmd: List[str], *, check: bool = True) -> str:
    result = subprocess.run(cmd, text=True, capture_output=True)
    if check and result.returncode != 0:
        raise RuntimeError(
            f"Command failed: {' '.join(cmd)}\n"
            f"stdout:\n{result.stdout}\n"
            f"stderr:\n{result.stderr}"
        )
    return result.stdout.strip()


def run_mutating(cmd: List[str], *, dry_run: bool) -> str:
    if dry_run:
        print(f"[dry-run] {' '.join(cmd)}")
        return ""
    return run(cmd)


def ensure_clean_worktree() -> None:
    status = run(["git", "status", "--porcelain"])
    if status:
        raise RuntimeError("Working tree is not clean. Commit or stash changes first.")


def ensure_origin_remote() -> None:
    remotes = run(["git", "remote"]).splitlines()
    if "origin" not in remotes:
        raise RuntimeError("No 'origin' remote found in this repo.")


def ensure_gh_auth() -> None:
    run(["gh", "auth", "status"])


def current_repo() -> str:
    data = json.loads(run(["gh", "repo", "view", "--json", "nameWithOwner"]))
    return data["nameWithOwner"]


def list_ready_prs() -> List[PullRequest]:
    data = json.loads(
        run(
            [
                "gh",
                "pr",
                "list",
                "--state",
                "open",
                "--label",
                LABEL,
                "--json",
                "number,title,url,headRefName,baseRefName,headRepository,isCrossRepository",
            ]
        )
    )
    prs: List[PullRequest] = []
    for item in data:
        prs.append(
            PullRequest(
                number=item["number"],
                title=item["title"],
                url=item["url"],
                head_ref=item["headRefName"],
                base_ref=item["baseRefName"],
                head_repo=item["headRepository"]["nameWithOwner"],
                is_cross_repo=item["isCrossRepository"],
            )
        )
    return prs


def checkout(branch: str, *, dry_run: bool) -> None:
    run_mutating(["git", "checkout", branch], dry_run=dry_run)


def update_branch(remote: str, branch: str, *, dry_run: bool) -> None:
    run_mutating(["git", "fetch", remote, branch], dry_run=dry_run)
    run_mutating(["git", "pull", "--ff-only", remote, branch], dry_run=dry_run)


def merge_ff(remote: str, source: str, *, dry_run: bool) -> None:
    run_mutating(["git", "merge", "--ff-only", f"{remote}/{source}"], dry_run=dry_run)


def push(remote: str, branch: str, *, dry_run: bool) -> None:
    run_mutating(["git", "push", remote, branch], dry_run=dry_run)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Fast-forward merge PRs labeled 'ready to merge'."
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print the commands that would run without mutating the repo.",
    )
    return parser.parse_args()


def main() -> int:
    try:
        args = parse_args()
        ensure_clean_worktree()
        ensure_origin_remote()
        ensure_gh_auth()
        repo = current_repo()
        prs = list_ready_prs()
        if not prs:
            print(f"No open PRs with label '{LABEL}'.")
            return 0

        original_branch = run(["git", "rev-parse", "--abbrev-ref", "HEAD"])

        for pr in prs:
            print(f"Processing PR #{pr.number}: {pr.title}")
            if pr.is_cross_repo or pr.head_repo != repo:
                print("Skipping PR because head repo does not match current repo.")
                continue
            if pr.base_ref == pr.head_ref:
                raise RuntimeError("PR base and head are the same branch.")

            run_mutating(["git", "fetch", "origin", pr.base_ref], dry_run=args.dry_run)
            run_mutating(["git", "fetch", "origin", pr.head_ref], dry_run=args.dry_run)
            checkout(pr.base_ref, dry_run=args.dry_run)
            update_branch("origin", pr.base_ref, dry_run=args.dry_run)
            merge_ff("origin", pr.head_ref, dry_run=args.dry_run)
            push("origin", pr.base_ref, dry_run=args.dry_run)
            if args.dry_run:
                print(
                    f"Dry-run: would fast-forward merge PR #{pr.number} into {pr.base_ref}."
                )
            else:
                print(f"Fast-forward merged PR #{pr.number} into {pr.base_ref}.")

        checkout(original_branch, dry_run=args.dry_run)
        return 0
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
