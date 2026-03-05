#!/usr/bin/env python3
"""List review threads for the open PR on the current branch."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from typing import Any

THREADS_QUERY = """\
query(
  $owner: String!,
  $repo: String!,
  $number: Int!,
  $cursor: String
) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      number
      url
      title
      reviewThreads(first: 100, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes {
          id
          isResolved
          isOutdated
          path
          line
          startLine
          originalLine
          originalStartLine
          comments(first: 100) {
            nodes {
              id
              body
              createdAt
              url
              author { login }
            }
          }
        }
      }
    }
  }
}
"""


def run(cmd: list[str], *, stdin: str | None = None) -> str:
    process = subprocess.run(cmd, input=stdin, capture_output=True, text=True)
    if process.returncode != 0:
        raise RuntimeError(process.stderr.strip() or f"command failed: {' '.join(cmd)}")
    return process.stdout


def run_json(cmd: list[str], *, stdin: str | None = None) -> dict[str, Any]:
    output = run(cmd, stdin=stdin)
    try:
        return json.loads(output)
    except json.JSONDecodeError as exc:
        raise RuntimeError(f"failed to parse JSON output: {exc}") from exc


def ensure_gh_auth() -> None:
    run(["gh", "auth", "status"])


def current_pr() -> dict[str, Any]:
    pr = run_json(
        [
            "gh",
            "pr",
            "view",
            "--json",
            "number,url,title,headRefName,baseRefName",
        ]
    )
    repo = run_json(["gh", "repo", "view", "--json", "owner,name"])
    pr["repositoryOwner"] = repo["owner"]["login"]
    pr["repositoryName"] = repo["name"]
    return pr


def fetch_threads(owner: str, repo: str, number: int) -> list[dict[str, Any]]:
    threads: list[dict[str, Any]] = []
    cursor: str | None = None

    while True:
        cmd = [
            "gh",
            "api",
            "graphql",
            "-F",
            "query=@-",
            "-F",
            f"owner={owner}",
            "-F",
            f"repo={repo}",
            "-F",
            f"number={number}",
        ]
        if cursor:
            cmd += ["-F", f"cursor={cursor}"]

        payload = run_json(cmd, stdin=THREADS_QUERY)
        if payload.get("errors"):
            raise RuntimeError(json.dumps(payload["errors"], indent=2))

        review_threads = payload["data"]["repository"]["pullRequest"]["reviewThreads"]
        threads.extend(review_threads.get("nodes") or [])

        page_info = review_threads["pageInfo"]
        if not page_info["hasNextPage"]:
            return threads
        cursor = page_info["endCursor"]


def normalize_threads(threads: list[dict[str, Any]], include_resolved: bool) -> list[dict[str, Any]]:
    result = []
    for thread in threads:
        if not include_resolved and thread["isResolved"]:
            continue
        comments = thread.get("comments", {}).get("nodes") or []
        result.append(
            {
                "thread_id": thread["id"],
                "is_resolved": thread["isResolved"],
                "is_outdated": thread["isOutdated"],
                "path": thread["path"],
                "line": thread["line"],
                "start_line": thread["startLine"],
                "original_line": thread["originalLine"],
                "original_start_line": thread["originalStartLine"],
                "comments": [
                    {
                        "comment_id": comment["id"],
                        "author": (comment.get("author") or {}).get("login"),
                        "created_at": comment["createdAt"],
                        "url": comment["url"],
                        "body": comment["body"],
                    }
                    for comment in comments
                ],
            }
        )
    return result


def render_text(pr: dict[str, Any], threads: list[dict[str, Any]]) -> str:
    lines = [
        f"PR #{pr['number']}: {pr['title']}",
        pr["url"],
        f"threads: {len(threads)}",
        "",
    ]

    for index, thread in enumerate(threads, start=1):
        line_info = thread["line"] or thread["original_line"] or "?"
        lines.append(f"[{index}] {thread['thread_id']}")
        lines.append(f"file: {thread['path']}:{line_info}")
        lines.append(f"resolved: {thread['is_resolved']}")
        lines.append(f"outdated: {thread['is_outdated']}")
        lines.append("comments:")
        for comment in thread["comments"]:
            author = comment["author"] or "unknown"
            body = " ".join(comment["body"].split())
            lines.append(f"- {author}: {body}")
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--all", action="store_true", help="include resolved threads")
    parser.add_argument(
        "--format",
        choices=("json", "text"),
        default="json",
        help="output format",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        ensure_gh_auth()
        pr = current_pr()
        owner = pr["repositoryOwner"]
        repo = pr["repositoryName"]
        threads = fetch_threads(owner=owner, repo=repo, number=int(pr["number"]))
        normalized = normalize_threads(threads, include_resolved=args.all)

        payload = {
            "pull_request": {
                "number": pr["number"],
                "url": pr["url"],
                "title": pr["title"],
                "head_ref": pr["headRefName"],
                "base_ref": pr["baseRefName"],
                "owner": owner,
                "repo": repo,
            },
            "review_threads": normalized,
        }

        if args.format == "json":
            print(json.dumps(payload, indent=2))
        else:
            print(render_text(payload["pull_request"], normalized), end="")
        return 0
    except Exception as exc:
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
