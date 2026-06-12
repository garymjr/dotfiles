#!/usr/bin/env python3
"""Report safe maintenance candidates for ~/.codex/rules/default.rules."""

from __future__ import annotations

import argparse
import ast
import json
import shlex
from collections import Counter, defaultdict
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any


BROAD_HEADS = {
    "bash",
    "env",
    "node",
    "perl",
    "python",
    "python3",
    "rm",
    "ruby",
    "sh",
    "zsh",
}

MUTATING_OR_SENSITIVE = {
    ("aws", "iam"),
    ("aws", "identitystore"),
    ("aws", "organizations"),
    ("aws", "sso-admin"),
    ("aws", "ssm", "send-command"),
    ("git", "reset"),
    ("git", "revert"),
    ("git", "push", "--force"),
    ("pulumi", "up"),
    ("terraform", "apply"),
    ("terraform", "destroy"),
    ("tofu", "apply"),
    ("tofu", "destroy"),
}

READ_ONLY_VERBS = (
    "cat",
    "find",
    "gh auth status",
    "gh issue list",
    "gh issue view",
    "gh pr checks",
    "gh pr diff",
    "gh pr list",
    "gh pr status",
    "gh pr view",
    "gh release list",
    "gh release view",
    "gh repo view",
    "gh run list",
    "gh run view",
    "gh workflow list",
    "gh workflow view",
    "git diff",
    "git fetch origin",
    "git log",
    "git show",
    "git status",
    "ls",
    "mise exec -- terraform fmt -check",
    "mise exec -- terraform plan",
    "mise exec -- terraform state list",
    "mise exec -- terraform validate",
    "rg",
    "sed",
    "terraform fmt -check",
    "terraform plan",
    "terraform state list",
    "terraform validate",
    "tofu plan",
    "tofu validate",
    "wc",
)


@dataclass
class Observation:
    pattern: tuple[str, ...]
    source: str
    command: str
    proposed: bool


def parse_args() -> argparse.Namespace:
    home = Path.home()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--days", type=int, default=7, help="Session lookback window.")
    parser.add_argument(
        "--sessions-dir",
        type=Path,
        default=home / ".codex" / "sessions",
        help="Codex sessions directory.",
    )
    parser.add_argument(
        "--rules-file",
        type=Path,
        default=home / ".codex" / "rules" / "default.rules",
        help="Rules file to compare against.",
    )
    parser.add_argument(
        "--min-count",
        type=int,
        default=2,
        help="Minimum repeated observations for addition candidates.",
    )
    parser.add_argument("--json", action="store_true", help="Emit JSON.")
    return parser.parse_args()


def flatten_pattern(value: Any) -> tuple[str, ...]:
    parts: list[str] = []
    if isinstance(value, list):
        for item in value:
            if isinstance(item, list):
                parts.append("[" + "|".join(str(piece) for piece in item) + "]")
            else:
                parts.append(str(item))
    return tuple(parts)


def parse_rule_patterns(path: Path) -> set[tuple[str, ...]]:
    if not path.exists():
        return set()
    lines = path.read_text().splitlines()
    patterns: set[tuple[str, ...]] = set()
    for index, line in enumerate(lines):
        if "pattern" not in line or "=" not in line:
            continue
        _, raw_value = line.split("=", 1)
        collected = [raw_value.strip().rstrip(",")]
        balance = collected[0].count("[") - collected[0].count("]")
        cursor = index + 1
        while balance > 0 and cursor < len(lines):
            piece = lines[cursor].strip().rstrip(",")
            collected.append(piece)
            balance += piece.count("[") - piece.count("]")
            cursor += 1
        expression = " ".join(collected)
        try:
            value = ast.literal_eval(expression)
        except (SyntaxError, ValueError):
            continue
        pattern = flatten_pattern(value)
        if pattern:
            patterns.add(pattern)
    return patterns


def session_files(sessions_dir: Path, days: int) -> list[Path]:
    if not sessions_dir.exists():
        return []
    cutoff = datetime.now(timezone.utc) - timedelta(days=days)
    files: list[Path] = []
    for path in sessions_dir.rglob("rollout-*.jsonl"):
        try:
            mtime = datetime.fromtimestamp(path.stat().st_mtime, timezone.utc)
        except OSError:
            continue
        if mtime >= cutoff:
            files.append(path)
    return sorted(files)


def parse_call_args(raw: Any) -> dict[str, Any] | None:
    if isinstance(raw, dict):
        return raw
    if not isinstance(raw, str):
        return None
    try:
        parsed = json.loads(raw)
    except json.JSONDecodeError:
        return None
    return parsed if isinstance(parsed, dict) else None


def infer_prefix(command: str) -> tuple[str, ...]:
    try:
        parts = shlex.split(command)
    except ValueError:
        parts = command.split()
    if not parts:
        return ()
    if parts[:4] == ["mise", "exec", "--", "terraform"] and len(parts) >= 5:
        return tuple(parts[:6] if parts[4] == "fmt" and len(parts) >= 6 else parts[:5])
    if parts[0] == "aws" and len(parts) >= 3:
        return tuple(parts[:3])
    if parts[0] == "gh" and len(parts) >= 3:
        return tuple(parts[:3])
    if parts[0] == "git" and len(parts) >= 3 and parts[1] == "fetch":
        return tuple(parts[:3])
    return tuple(parts[:2] if len(parts) >= 2 else parts[:1])


def observations_from_file(path: Path) -> list[Observation]:
    observations: list[Observation] = []
    try:
        lines = path.read_text(errors="replace").splitlines()
    except OSError:
        return observations
    for line in lines:
        try:
            record = json.loads(line)
        except json.JSONDecodeError:
            continue
        payload = record.get("payload")
        if not isinstance(payload, dict):
            continue
        if payload.get("type") != "function_call" or payload.get("name") != "exec_command":
            continue
        args = parse_call_args(payload.get("arguments"))
        if not args or args.get("sandbox_permissions") != "require_escalated":
            continue
        command = str(args.get("cmd", ""))
        raw_prefix = args.get("prefix_rule")
        prefix = flatten_pattern(raw_prefix) if raw_prefix else infer_prefix(command)
        if not prefix:
            continue
        observations.append(
            Observation(
                pattern=prefix,
                source=str(path),
                command=command,
                proposed=bool(raw_prefix),
            )
        )
    return observations


def is_existing_match(pattern: tuple[str, ...], existing: set[tuple[str, ...]]) -> bool:
    if pattern in existing:
        return True
    for current in existing:
        if len(current) > len(pattern):
            continue
        matched = True
        for wanted, observed in zip(current, pattern):
            if wanted.startswith("[") and wanted.endswith("]"):
                choices = set(wanted[1:-1].split("|"))
                if observed not in choices:
                    matched = False
                    break
            elif wanted != observed:
                matched = False
                break
        if matched:
            return True
    return False


def classify(pattern: tuple[str, ...], count: int, existing: set[tuple[str, ...]], min_count: int) -> str:
    if is_existing_match(pattern, existing):
        return "duplicate"
    if count < min_count:
        return "below-threshold"
    if pattern and pattern[0] in BROAD_HEADS:
        return "broad-interpreter-or-destructive"
    for risky in MUTATING_OR_SENSITIVE:
        if pattern[: len(risky)] == risky:
            return "mutating-or-sensitive"
    joined = " ".join(pattern)
    if any(joined.startswith(verb) for verb in READ_ONLY_VERBS):
        return "candidate"
    return "needs-human-review"


def render_text(report: dict[str, Any]) -> str:
    lines: list[str] = []
    lines.append(f"Window: last {report['days']} day(s)")
    lines.append(f"Session files scanned: {report['session_file_count']}")
    lines.append(f"Rules file: {report['rules_file']}")
    lines.append("")

    lines.append("Observed approval prefixes:")
    if report["observed"]:
        for item in report["observed"]:
            lines.append(f"- {item['count']}x {item['pattern']} ({item['classification']})")
            lines.append(f"  example: {item['example_command']}")
    else:
        lines.append("- none")
    lines.append("")

    lines.append("Candidate additions:")
    candidates = [item for item in report["observed"] if item["classification"] == "candidate"]
    if candidates:
        for item in candidates:
            lines.append(f"- {item['pattern']} ({item['count']} observations)")
    else:
        lines.append("- none")
    lines.append("")

    lines.append("Stale existing rules with no observed usage in this window:")
    if report["stale_existing_rules"]:
        for pattern in report["stale_existing_rules"]:
            lines.append(f"- {pattern}")
    else:
        lines.append("- none")
    lines.append("")

    lines.append("Skipped candidates:")
    skipped = [item for item in report["observed"] if item["classification"] != "candidate"]
    if skipped:
        for item in skipped:
            lines.append(f"- {item['pattern']}: {item['classification']}")
    else:
        lines.append("- none")
    return "\n".join(lines)


def main() -> int:
    args = parse_args()
    existing = parse_rule_patterns(args.rules_file)
    observations: list[Observation] = []
    for path in session_files(args.sessions_dir, args.days):
        observations.extend(observations_from_file(path))

    counts = Counter(obs.pattern for obs in observations)
    examples: dict[tuple[str, ...], Observation] = {}
    sources: dict[tuple[str, ...], set[str]] = defaultdict(set)
    for obs in observations:
        examples.setdefault(obs.pattern, obs)
        sources[obs.pattern].add(obs.source)

    observed = []
    for pattern, count in counts.most_common():
        example = examples[pattern]
        observed.append(
            {
                "pattern": list(pattern),
                "count": count,
                "classification": classify(pattern, count, existing, args.min_count),
                "example_command": example.command,
                "example_source": example.source,
                "source_count": len(sources[pattern]),
                "explicit_prefix_rule_seen": any(obs.proposed for obs in observations if obs.pattern == pattern),
            }
        )

    observed_patterns = set(counts)
    stale = [
        list(pattern)
        for pattern in sorted(existing)
        if not any(is_existing_match(observed, {pattern}) for observed in observed_patterns)
    ]

    report = {
        "days": args.days,
        "rules_file": str(args.rules_file),
        "session_file_count": len(session_files(args.sessions_dir, args.days)),
        "existing_rule_count": len(existing),
        "observed": observed,
        "stale_existing_rules": stale,
    }

    if args.json:
        print(json.dumps(report, indent=2))
    else:
        print(render_text(report))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
