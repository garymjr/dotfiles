#!/usr/bin/env python3
"""Summarize recent Codex sandbox-related evidence by likely CLI.

The default output avoids printing raw transcript lines. Use --snippets only
when you have checked that the target evidence is safe to display.
"""

from __future__ import annotations

import argparse
import collections
import datetime as dt
import os
import re
from pathlib import Path


CODEX_HOME = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex"))
DEFAULT_ROOTS = [
    CODEX_HOME / "memories" / "rollout_summaries",
    CODEX_HOME / "sessions",
    CODEX_HOME / "archived_sessions",
]

PATTERNS: list[tuple[str, str, re.Pattern[str]]] = [
    ("swiftpm-cli", "swiftpm sandbox_apply", re.compile(r"swift|SwiftPM|sandbox_apply|sandbox-exec", re.I)),
    ("go-cli", "go cache permission", re.compile(r"GOCACHE|go-build|go test|go build", re.I)),
    ("aws-cli", "aws cache or sso", re.compile(r"\baws\b|\.aws/(?:sso|cli|login)/cache|SSO|sso login", re.I)),
    ("git-cli", "git metadata", re.compile(r"\bgit\b|\.git/(?:config|worktrees)|rebase-merge|GIT_EDITOR", re.I)),
    ("mise", "mise trust or cache", re.compile(r"\bmise\b|mise trust|Library/Caches/mise", re.I)),
    ("opentofu", "tofu temp state", re.compile(r"\btofu\b|OpenTofu|TF_DATA_DIR|TF_PLUGIN_CACHE_DIR", re.I)),
    ("npm-cli", "npm cache or install", re.compile(r"\bnpm\b|node_modules|npm cache", re.I)),
    ("cargo-cli", "cargo cache or build", re.compile(r"\bcargo\b|CARGO_HOME|target/debug|target/release", re.I)),
    ("xcodebuild-cli", "xcodebuild derived data", re.compile(r"xcodebuild|DerivedData", re.I)),
]

EVIDENCE_RE = re.compile(
    r"sandbox_apply|Operation not permitted|Permission denied|EACCES|EPERM|Read-only file system|"
    r"could not resolve host|Temporary failure in name resolution|failed to fetch|"
    r"sandbox/cache warnings|cache-write warnings|blocked writing|could not lock config file",
    re.I,
)
NOISE_RE = re.compile(
    r"base_instructions|permissions instructions|sandbox_mode|approval policy|"
    r"Tool definitions|namespace|function|schema|guardian|You are judging",
    re.I,
)


def iter_files(root: Path, cutoff: float) -> list[Path]:
    if not root.exists():
        return []
    files: list[Path] = []
    for path in root.rglob("*"):
        if not path.is_file():
            continue
        if path.suffix not in {".jsonl", ".md"}:
            continue
        try:
            if path.stat().st_mtime >= cutoff:
                files.append(path)
        except OSError:
            continue
    return files


def classify(line: str) -> list[tuple[str, str]]:
    if NOISE_RE.search(line) and not re.search(r"tool_result|exec_command|event_msg|Failures and how", line):
        return []
    if not EVIDENCE_RE.search(line):
        return []
    hits: list[tuple[str, str]] = []
    for cli, label, pattern in PATTERNS:
        if pattern.search(line):
            hits.append((cli, label))
    if not hits:
        hits.append(("unknown-cli", "sandbox or permission"))
    return hits


def safe_snippet(line: str, width: int = 180) -> str:
    compact = re.sub(r"\s+", " ", line).strip()
    compact = re.sub(r"([A-Z0-9]{4}-){1,}[A-Z0-9]{4}", "<redacted-code>", compact)
    compact = re.sub(r"(?i)(token|secret|password|credential)[^,;\\s]{0,80}", r"\1=<redacted>", compact)
    return compact[:width]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--days", type=int, default=7)
    parser.add_argument("--root", action="append", type=Path, help="Additional or replacement root to scan")
    parser.add_argument("--snippets", action="store_true", help="Print sanitized snippets for matched lines")
    args = parser.parse_args()

    cutoff = (dt.datetime.now().timestamp()) - args.days * 24 * 60 * 60
    roots = args.root if args.root else DEFAULT_ROOTS
    evidence: dict[str, list[tuple[Path, int, str, str]]] = collections.defaultdict(list)

    for root in roots:
        for path in iter_files(root.expanduser(), cutoff):
            try:
                with path.open("r", encoding="utf-8", errors="replace") as fh:
                    for line_no, line in enumerate(fh, 1):
                        for cli, label in classify(line):
                            evidence[cli].append((path, line_no, label, line))
            except OSError:
                continue

    print(f"Scanned roots: {', '.join(str(r.expanduser()) for r in roots)}")
    print(f"Lookback days: {args.days}")
    print()

    if not evidence:
        print("No sandbox-related CLI evidence found.")
        return 0

    for cli in sorted(evidence, key=lambda key: (-len(evidence[key]), key)):
        rows = evidence[cli]
        files = collections.Counter(path for path, _, _, _ in rows)
        labels = collections.Counter(label for _, _, label, _ in rows)
        print(f"## {cli}")
        print(f"matches: {len(rows)}")
        print("labels: " + ", ".join(f"{label}={count}" for label, count in labels.most_common()))
        print("top files:")
        for path, count in files.most_common(8):
            line_numbers = [line_no for p, line_no, _, _ in rows if p == path][:6]
            rel = path
            try:
                rel = path.relative_to(CODEX_HOME)
            except ValueError:
                pass
            print(f"- {rel}: {count} matches; lines {', '.join(map(str, line_numbers))}")
            if args.snippets:
                for p, line_no, label, line in rows:
                    if p == path and line_no in line_numbers[:2]:
                        print(f"  - line {line_no} [{label}]: {safe_snippet(line)}")
        print()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
