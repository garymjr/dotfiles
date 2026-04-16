#!/usr/bin/env python3
"""
Inventory diff slices and emit synthetic patch files for selected ids.
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path

HUNK_RE = re.compile(
    r"^@@ -(?P<old_start>\d+)(?:,(?P<old_count>\d+))? "
    r"\+(?P<new_start>\d+)(?:,(?P<new_count>\d+))? @@(?P<title>.*)$"
)
DIFF_HEADER_RE = re.compile(r"^diff --git a/(.+) b/(.+)$")


@dataclass
class SliceItem:
    item_id: str
    kind: str
    change_type: str
    file_path: str
    summary: str
    lines: list[str]


@dataclass
class FileDiff:
    file_path: str
    change_type: str
    header_lines: list[str] = field(default_factory=list)
    items: list[SliceItem] = field(default_factory=list)


def build_git_diff_command(repo: Path, cached: bool, base: str | None, context: int) -> list[str]:
    cmd = [
        "git",
        "-C",
        str(repo),
        "-c",
        "core.quotePath=false",
        "diff",
        "--no-color",
        "--no-ext-diff",
        "--binary",
        "--find-renames",
        f"--unified={context}",
    ]
    if cached:
        cmd.append("--cached")
    if base:
        cmd.append(base)
    return cmd


def load_diff(repo: Path, cached: bool, base: str | None, context: int) -> str:
    cmd = build_git_diff_command(repo, cached, base, context)
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(result.stderr.strip() or "git diff failed", file=sys.stderr)
        raise SystemExit(result.returncode)
    diff_text = result.stdout
    if not cached:
        diff_text += load_untracked_diffs(repo)
    return diff_text


def load_untracked_diffs(repo: Path) -> str:
    list_cmd = [
        "git",
        "-C",
        str(repo),
        "ls-files",
        "--others",
        "--exclude-standard",
        "-z",
    ]
    listed = subprocess.run(list_cmd, capture_output=True, check=False)
    if listed.returncode != 0:
        print(listed.stderr.decode().strip() or "git ls-files failed", file=sys.stderr)
        raise SystemExit(listed.returncode)

    untracked_paths = [entry.decode() for entry in listed.stdout.split(b"\0") if entry]
    patches: list[str] = []
    for rel_path in untracked_paths:
        diff_cmd = [
            "git",
            "-C",
            str(repo),
            "-c",
            "core.quotePath=false",
            "diff",
            "--no-index",
            "--no-color",
            "--no-ext-diff",
            "--binary",
            "--find-renames",
            "--",
            "/dev/null",
            rel_path,
        ]
        generated = subprocess.run(diff_cmd, capture_output=True, text=True)
        if generated.returncode not in (0, 1):
            print(
                generated.stderr.strip() or f"git diff --no-index failed for {rel_path}",
                file=sys.stderr,
            )
            raise SystemExit(generated.returncode)
        patches.append(generated.stdout)

    return "".join(patches)


def parse_file_path(diff_header: str) -> str:
    match = DIFF_HEADER_RE.match(diff_header.rstrip("\n"))
    if match:
        return match.group(2)
    raise ValueError(f"Unexpected diff header: {diff_header.rstrip()}")


def detect_change_type(header_lines: list[str]) -> str:
    if any(line.startswith("new file mode ") for line in header_lines):
        return "new"
    if any(line.startswith("deleted file mode ") for line in header_lines):
        return "delete"
    if any(line.startswith("rename from ") for line in header_lines):
        return "rename"
    if any(line.startswith("copy from ") for line in header_lines):
        return "copy"
    if any(line.startswith("old mode ") or line.startswith("new mode ") for line in header_lines):
        return "mode"
    return "modify"


def format_hunk_summary(hunk_header: str) -> str:
    match = HUNK_RE.match(hunk_header.rstrip("\n"))
    if not match:
        return hunk_header.rstrip("\n")
    old_start = match.group("old_start")
    old_count = match.group("old_count") or "1"
    new_start = match.group("new_start")
    new_count = match.group("new_count") or "1"
    title = match.group("title").strip()
    summary = f"-{old_start},{old_count} +{new_start},{new_count}"
    if title:
        summary = f"{summary} {title}"
    return summary


def parse_diff(diff_text: str) -> list[FileDiff]:
    if not diff_text:
        return []

    lines = diff_text.splitlines(keepends=True)
    files: list[FileDiff] = []
    i = 0
    next_hunk_id = 1
    next_file_id = 1

    while i < len(lines):
        line = lines[i]
        if not line.startswith("diff --git "):
            i += 1
            continue

        block_lines = [line]
        i += 1
        while i < len(lines) and not lines[i].startswith("diff --git "):
            block_lines.append(lines[i])
            i += 1

        file_path = parse_file_path(block_lines[0])
        header_lines: list[str] = []
        hunk_groups: list[list[str]] = []
        cursor = 0
        while cursor < len(block_lines):
            current = block_lines[cursor]
            if cursor > 0 and current.startswith("@@ "):
                hunk = [current]
                cursor += 1
                while cursor < len(block_lines):
                    upcoming = block_lines[cursor]
                    if upcoming.startswith("@@ ") or upcoming.startswith("diff --git "):
                        break
                    hunk.append(upcoming)
                    cursor += 1
                hunk_groups.append(hunk)
                continue
            header_lines.append(current)
            cursor += 1

        change_type = detect_change_type(header_lines)
        file_diff = FileDiff(
            file_path=file_path,
            change_type=change_type,
            header_lines=header_lines,
        )

        file_level_change = change_type != "modify" or not hunk_groups
        if not file_level_change:
            for hunk in hunk_groups:
                item_id = f"H{next_hunk_id:03d}"
                next_hunk_id += 1
                file_diff.items.append(
                    SliceItem(
                        item_id=item_id,
                        kind="hunk",
                        change_type=change_type,
                        file_path=file_path,
                        summary=format_hunk_summary(hunk[0]),
                        lines=hunk,
                    )
                )
        else:
            item_id = f"F{next_file_id:03d}"
            next_file_id += 1
            file_diff.header_lines = block_lines
            file_diff.items.append(
                SliceItem(
                    item_id=item_id,
                    kind="file",
                    change_type=change_type,
                    file_path=file_path,
                    summary="whole-file change",
                    lines=[],
                )
            )

        files.append(file_diff)

    return files


def flatten_items(files: list[FileDiff]) -> list[SliceItem]:
    items: list[SliceItem] = []
    for file_diff in files:
        items.extend(file_diff.items)
    return items


def emit_inventory(files: list[FileDiff]) -> int:
    items = flatten_items(files)
    if not items:
        print("No diff slices found.")
        return 0

    print("id\tkind\tchange\tfile\tsummary")
    for item in items:
        print(
            f"{item.item_id}\t{item.kind}\t{item.change_type}\t"
            f"{item.file_path}\t{item.summary}"
        )
    return 0


def emit_patch(files: list[FileDiff], selected_ids: list[str]) -> str:
    selected = set(selected_ids)
    known_ids = {item.item_id for item in flatten_items(files)}
    unknown = [item_id for item_id in selected_ids if item_id not in known_ids]
    if unknown:
        raise ValueError(f"Unknown slice id(s): {', '.join(unknown)}")

    output_lines: list[str] = []
    for file_diff in files:
        chosen_items = [item for item in file_diff.items if item.item_id in selected]
        if not chosen_items:
            continue
        output_lines.extend(file_diff.header_lines)
        for item in chosen_items:
            output_lines.extend(item.lines)
    return "".join(output_lines)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Inventory git diff hunks and emit synthetic patch files."
    )
    parser.add_argument(
        "--repo",
        default=".",
        help="Path to the target git repository (default: current directory)",
    )
    parser.add_argument(
        "--cached",
        action="store_true",
        help="Read the staged diff instead of the working tree diff",
    )
    parser.add_argument(
        "--base",
        help="Compare the working tree or index against a specific base revision",
    )
    parser.add_argument(
        "--context",
        type=int,
        default=3,
        help="Unified diff context lines to request from git diff (default: 3)",
    )

    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("inventory", help="Print selectable diff slice ids")

    emit_parser = subparsers.add_parser("emit-patch", help="Write a patch for selected slice ids")
    emit_parser.add_argument(
        "--ids",
        required=True,
        help="Comma-separated slice ids such as H001,H004,F001",
    )
    emit_parser.add_argument(
        "--output",
        help="Optional output file path. Prints to stdout when omitted.",
    )

    return parser.parse_args()


def main() -> int:
    args = parse_args()
    repo = Path(args.repo).resolve()
    diff_text = load_diff(repo=repo, cached=args.cached, base=args.base, context=args.context)
    files = parse_diff(diff_text)

    if args.command == "inventory":
        return emit_inventory(files)

    raw_ids = [item.strip() for item in args.ids.split(",") if item.strip()]
    if not raw_ids:
        print("No slice ids provided.", file=sys.stderr)
        return 1

    try:
        patch_text = emit_patch(files, raw_ids)
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    if args.output:
        output_path = Path(args.output).resolve()
        output_path.write_text(patch_text)
    else:
        sys.stdout.write(patch_text)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
