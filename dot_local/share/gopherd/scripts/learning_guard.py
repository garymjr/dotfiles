#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import re
import sys
from dataclasses import dataclass
from datetime import datetime, timedelta
from pathlib import Path
from zoneinfo import ZoneInfo


TZ = ZoneInfo("America/Denver")
CORE_FILES = ("AGENTS.md", "SOUL.md", "IDENTITY.md", "USER.md", "HEARTBEAT.md")
LEARN_RE = re.compile(r"\bLEARN\s+\[(L\d{8}-\d{3})\]:")
PROMOTED_RE = re.compile(r"\bPROMOTED\s+\[(L\d{8}-\d{3})\]")
DISCARDED_RE = re.compile(r"\bDISCARDED\s+\[(L\d{8}-\d{3})\]")
LEARN_LINE_RE = re.compile(
    r"LEARN\s+\[(L\d{8}-\d{3})\](?:\s*->\s*([A-Za-z0-9_.-]+))?:\s*(.+)$",
    re.MULTILINE,
)
AUTO_START = "<!-- AUTO_LEARNINGS_START -->"
AUTO_END = "<!-- AUTO_LEARNINGS_END -->"


@dataclass
class LearnState:
    learns: set[str]
    promoted: set[str]
    discarded: set[str]


@dataclass
class LearnRecord:
    learn_id: str
    target: str | None
    text: str
    source: Path


def now_local() -> datetime:
    return datetime.now(TZ)


def today_string() -> str:
    return now_local().strftime("%Y-%m-%d")


def memory_path(root: Path, date_str: str) -> Path:
    return root / "memory" / f"{date_str}.md"


def ensure_memory_file(path: Path, date_str: str) -> None:
    if path.exists():
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(f"# {date_str}\n\n## Learning Loop\n", encoding="utf-8")


def append_line(path: Path, line: str) -> None:
    text = path.read_text(encoding="utf-8")
    if text and not text.endswith("\n"):
        text += "\n"
    text += f"{line}\n"
    path.write_text(text, encoding="utf-8")


def core_digests(root: Path) -> list[str]:
    digests: list[str] = []
    for name in CORE_FILES:
        path = root / name
        if not path.exists():
            raise FileNotFoundError(f"missing core file: {name}")
        digest = hashlib.sha256(path.read_bytes()).hexdigest()[:10]
        digests.append(f"{name}@{digest}")
    return digests


def read_state(path: Path) -> LearnState:
    text = path.read_text(encoding="utf-8")
    learns = set(LEARN_RE.findall(text))
    promoted = set(PROMOTED_RE.findall(text))
    discarded = set(DISCARDED_RE.findall(text))
    return LearnState(learns=learns, promoted=promoted, discarded=discarded)


def read_learn_records(path: Path) -> list[LearnRecord]:
    text = path.read_text(encoding="utf-8")
    records: list[LearnRecord] = []
    for match in LEARN_LINE_RE.finditer(text):
        learn_id, target, body = match.groups()
        records.append(
            LearnRecord(
                learn_id=learn_id,
                target=target,
                text=body.strip(),
                source=path,
            )
        )
    return records


def recent_memory_paths(root: Path, days: int) -> list[Path]:
    paths: list[Path] = []
    today = now_local().date()
    for offset in range(days):
        d = today - timedelta(days=offset)
        p = memory_path(root, d.strftime("%Y-%m-%d"))
        if p.exists():
            paths.append(p)
    return paths


def collect_recent_learn_data(root: Path, days: int) -> tuple[dict[str, LearnRecord], set[str]]:
    records: dict[str, LearnRecord] = {}
    resolved: set[str] = set()
    for path in sorted(recent_memory_paths(root, days)):
        state = read_state(path)
        resolved.update(state.promoted)
        resolved.update(state.discarded)
        for record in read_learn_records(path):
            records[record.learn_id] = record
    return records, resolved


def ensure_auto_block(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    has_start = AUTO_START in text
    has_end = AUTO_END in text
    if has_start and has_end:
        return
    if has_start != has_end:
        raise ValueError(f"{path} has incomplete auto-learning markers")
    suffix = (
        "\n\n## Auto Learnings\n\n"
        "Managed by `python3 scripts/learning_guard.py align --days 14`.\n\n"
        f"{AUTO_START}\n{AUTO_END}\n"
    )
    path.write_text(text.rstrip("\n") + suffix, encoding="utf-8")


def insert_auto_learning(path: Path, learn_id: str, body: str) -> bool:
    lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
    start_idx = next((i for i, line in enumerate(lines) if AUTO_START in line), -1)
    end_idx = next(
        (i for i, line in enumerate(lines) if AUTO_END in line and i > start_idx),
        -1,
    )
    if start_idx == -1 or end_idx == -1:
        raise ValueError(f"{path} missing auto-learning markers")
    needle = f"[{learn_id}]"
    if any(needle in line for line in lines[start_idx + 1 : end_idx]):
        return False
    lines.insert(end_idx, f"- [{learn_id}] {body}\n")
    path.write_text("".join(lines), encoding="utf-8")
    return True


def bootstrap(args: argparse.Namespace) -> int:
    root = Path(args.root).resolve()
    date_str = today_string()
    mem = memory_path(root, date_str)
    ensure_memory_file(mem, date_str)
    stamp = now_local().strftime("%Y-%m-%d %I:%M %p %Z")
    digest_str = ", ".join(core_digests(root))
    append_line(mem, f"- {stamp}: CORE_REVIEW_DONE {digest_str}")
    print(f"Logged core review in {mem}")
    return 0


def gate(args: argparse.Namespace) -> int:
    root = Path(args.root).resolve()
    date_str = today_string()
    today_mem = memory_path(root, date_str)
    if not today_mem.exists():
        print(f"FAIL: missing today's memory file: {today_mem}")
        return 1

    text = today_mem.read_text(encoding="utf-8")
    errors: list[str] = []

    if "CORE_REVIEW_DONE" not in text:
        errors.append("missing CORE_REVIEW_DONE entry for today")

    if f"MEMORY_REVIEW_DONE: {date_str}" not in text:
        errors.append(f"missing MEMORY_REVIEW_DONE marker for {date_str}")

    records, resolved = collect_recent_learn_data(root, args.days)
    unresolved = sorted(set(records.keys()) - resolved)
    if unresolved:
        errors.append(f"unresolved learning ids: {', '.join(unresolved)}")

    if errors:
        for err in errors:
            print(f"FAIL: {err}")
        return 1

    print("PASS: learning gate checks succeeded")
    return 0


def add_learn(args: argparse.Namespace) -> int:
    root = Path(args.root).resolve()
    date_str = today_string()
    day_code = date_str.replace("-", "")
    mem = memory_path(root, date_str)
    ensure_memory_file(mem, date_str)
    text = mem.read_text(encoding="utf-8")
    ids = re.findall(rf"\bL{day_code}-(\d{{3}})\b", text)
    next_id = int(max(ids, default="0")) + 1
    learn_id = f"L{day_code}-{next_id:03d}"
    stamp = now_local().strftime("%Y-%m-%d %I:%M %p %Z")
    if args.target:
        append_line(
            mem,
            f"- {stamp}: LEARN [{learn_id}] -> {args.target}: {args.text.strip()}",
        )
    else:
        append_line(mem, f"- {stamp}: LEARN [{learn_id}]: {args.text.strip()}")
    print(learn_id)
    return 0


def align(args: argparse.Namespace) -> int:
    root = Path(args.root).resolve()
    date_str = today_string()
    mem = memory_path(root, date_str)
    ensure_memory_file(mem, date_str)
    records, resolved = collect_recent_learn_data(root, args.days)
    pending = [
        record
        for learn_id, record in sorted(records.items())
        if learn_id not in resolved and record.target in CORE_FILES
    ]

    aligned = 0
    unresolved_targets: list[str] = []
    for record in pending:
        target_path = root / str(record.target)
        if not target_path.exists():
            unresolved_targets.append(
                f"{record.learn_id} -> {record.target} (missing target file)"
            )
            continue
        ensure_auto_block(target_path)
        insert_auto_learning(target_path, record.learn_id, record.text)
        stamp = now_local().strftime("%Y-%m-%d %I:%M %p %Z")
        append_line(
            mem,
            (
                f"- {stamp}: PROMOTED [{record.learn_id}] -> {record.target}: "
                "auto-aligned from LEARN ledger"
            ),
        )
        aligned += 1

    if unresolved_targets:
        for item in unresolved_targets:
            print(f"FAIL: {item}")
        return 1

    print(f"Aligned {aligned} learning item(s)")
    return 0


def promote(args: argparse.Namespace) -> int:
    root = Path(args.root).resolve()
    date_str = today_string()
    mem = memory_path(root, date_str)
    ensure_memory_file(mem, date_str)
    stamp = now_local().strftime("%Y-%m-%d %I:%M %p %Z")
    append_line(
        mem,
        f"- {stamp}: PROMOTED [{args.learn_id}] -> {args.target}: {args.note.strip()}",
    )
    print(f"Logged PROMOTED {args.learn_id}")
    return 0


def discard(args: argparse.Namespace) -> int:
    root = Path(args.root).resolve()
    date_str = today_string()
    mem = memory_path(root, date_str)
    ensure_memory_file(mem, date_str)
    stamp = now_local().strftime("%Y-%m-%d %I:%M %p %Z")
    append_line(mem, f"- {stamp}: DISCARDED [{args.learn_id}]: {args.reason.strip()}")
    print(f"Logged DISCARDED {args.learn_id}")
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Learning loop guardrails.")
    parser.add_argument(
        "--root",
        default=str(Path(__file__).resolve().parents[1]),
        help="Workspace root (defaults to repo root).",
    )
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_bootstrap = sub.add_parser("bootstrap", help="Log core file review stamp.")
    p_bootstrap.set_defaults(func=bootstrap)

    p_gate = sub.add_parser("gate", help="Validate learning loop requirements.")
    p_gate.add_argument(
        "--days",
        type=int,
        default=14,
        help="Lookback window for unresolved LEARN items.",
    )
    p_gate.set_defaults(func=gate)

    p_learn = sub.add_parser("learn", help="Add a LEARN item to today's memory.")
    p_learn.add_argument("--text", required=True, help="Learning statement.")
    p_learn.add_argument(
        "--target",
        help=(
            "Optional target file for auto-alignment "
            "(for example USER.md or SOUL.md)."
        ),
    )
    p_learn.set_defaults(func=add_learn)

    p_align = sub.add_parser(
        "align",
        help="Auto-promote unresolved targeted LEARN items into core identity files.",
    )
    p_align.add_argument(
        "--days",
        type=int,
        default=14,
        help="Lookback window for unresolved LEARN items.",
    )
    p_align.set_defaults(func=align)

    p_promote = sub.add_parser("promote", help="Resolve a LEARN as promoted.")
    p_promote.add_argument("--id", dest="learn_id", required=True, help="LEARN id.")
    p_promote.add_argument(
        "--target",
        required=True,
        help="File updated with this learning (for example USER.md).",
    )
    p_promote.add_argument("--note", required=True, help="Change summary.")
    p_promote.set_defaults(func=promote)

    p_discard = sub.add_parser("discard", help="Resolve a LEARN as discarded.")
    p_discard.add_argument("--id", dest="learn_id", required=True, help="LEARN id.")
    p_discard.add_argument("--reason", required=True, help="Why this is discarded.")
    p_discard.set_defaults(func=discard)

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
