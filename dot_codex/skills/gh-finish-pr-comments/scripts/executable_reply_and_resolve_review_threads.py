#!/usr/bin/env python3
"""Reply to and resolve selected review threads on the open PR."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path
from typing import Any

ADD_REPLY_MUTATION = """\
mutation($threadId: ID!, $body: String!) {
  addPullRequestReviewThreadReply(
    input: {
      pullRequestReviewThreadId: $threadId,
      body: $body
    }
  ) {
    comment {
      id
      url
    }
  }
}
"""

RESOLVE_THREAD_MUTATION = """\
mutation($threadId: ID!) {
  resolveReviewThread(input: {threadId: $threadId}) {
    thread {
      id
      isResolved
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


def load_plan(path: str | None) -> list[dict[str, Any]]:
    if path:
        raw = Path(path).read_text()
    else:
        raw = sys.stdin.read()

    if not raw.strip():
        raise RuntimeError("no input plan provided")

    data = json.loads(raw)
    if isinstance(data, list):
        threads = data
    else:
        threads = data.get("threads")

    if not isinstance(threads, list) or not threads:
        raise RuntimeError("input must contain a non-empty 'threads' array")

    normalized = []
    for index, thread in enumerate(threads, start=1):
        if not isinstance(thread, dict):
            raise RuntimeError(f"thread entry {index} must be an object")
        thread_id = thread.get("thread_id")
        body = thread.get("body")
        resolve = bool(thread.get("resolve"))

        if not isinstance(thread_id, str) or not thread_id.strip():
            raise RuntimeError(f"thread entry {index} is missing thread_id")
        if body is not None and (not isinstance(body, str) or not body.strip()):
            raise RuntimeError(f"thread entry {index} has an empty body")
        if body is None and not resolve:
            raise RuntimeError(f"thread entry {index} must include a body, resolve=true, or both")

        normalized.append(
            {
                "thread_id": thread_id.strip(),
                "body": body.strip() if isinstance(body, str) else None,
                "resolve": resolve,
            }
        )
    return normalized


def graphql(query: str, **variables: str) -> dict[str, Any]:
    cmd = ["gh", "api", "graphql", "-F", "query=@-"]
    for key, value in variables.items():
        cmd += ["-F", f"{key}={value}"]
    payload = run_json(cmd, stdin=query)
    if payload.get("errors"):
        raise RuntimeError(json.dumps(payload["errors"], indent=2))
    return payload


def apply_thread_operation(thread: dict[str, Any], dry_run: bool) -> dict[str, Any]:
    result: dict[str, Any] = {
        "thread_id": thread["thread_id"],
        "reply_posted": False,
        "reply_url": None,
        "resolved": False,
        "dry_run": dry_run,
    }

    if dry_run:
        result["reply_posted"] = bool(thread["body"])
        result["resolved"] = bool(thread["resolve"])
        return result

    if thread["body"]:
        payload = graphql(
            ADD_REPLY_MUTATION,
            threadId=thread["thread_id"],
            body=thread["body"],
        )
        comment = payload["data"]["addPullRequestReviewThreadReply"]["comment"]
        result["reply_posted"] = True
        result["reply_url"] = comment["url"]

    if thread["resolve"]:
        payload = graphql(RESOLVE_THREAD_MUTATION, threadId=thread["thread_id"])
        result["resolved"] = payload["data"]["resolveReviewThread"]["thread"]["isResolved"]

    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", help="path to a JSON plan file; defaults to stdin")
    parser.add_argument("--dry-run", action="store_true", help="print the planned actions without calling GitHub")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        ensure_gh_auth()
        threads = load_plan(args.input)
        results = [apply_thread_operation(thread, args.dry_run) for thread in threads]
        print(json.dumps({"threads": results}, indent=2))
        return 0
    except Exception as exc:
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
