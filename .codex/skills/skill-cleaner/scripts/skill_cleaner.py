#!/usr/bin/env python3
"""Audit local Codex skills for recent usage and metadata budget pressure."""

from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Iterable


FRONTMATTER_RE = re.compile(r"\A---\s*\n(.*?)\n---\s*\n", re.DOTALL)
DESCRIPTION_RE = re.compile(r"^description:\s*(.*)$", re.MULTILINE)
NAME_RE = re.compile(r"^name:\s*(.*)$", re.MULTILINE)


@dataclass
class Skill:
    name: str
    path: Path
    description: str
    approx_tokens: int
    is_system: bool


def parse_scalar(raw: str) -> str:
    raw = raw.strip()
    if len(raw) >= 2 and raw[0] == raw[-1] and raw[0] in {'"', "'"}:
        return raw[1:-1]
    return raw


def approx_tokens(text: str) -> int:
    if not text:
        return 0
    # Cheap approximation suitable for budget triage.
    return max(1, round(len(text) / 4))


def load_skill(skill_md: Path, skills_dir: Path) -> Skill | None:
    text = skill_md.read_text(encoding="utf-8", errors="replace")
    match = FRONTMATTER_RE.match(text)
    if not match:
        return None
    frontmatter = match.group(1)
    name_match = NAME_RE.search(frontmatter)
    description_match = DESCRIPTION_RE.search(frontmatter)
    if not name_match or not description_match:
        return None
    name = parse_scalar(name_match.group(1))
    description = parse_scalar(description_match.group(1))
    rel_parts = skill_md.relative_to(skills_dir).parts
    return Skill(
        name=name,
        path=skill_md.parent,
        description=description,
        approx_tokens=approx_tokens(description),
        is_system=bool(rel_parts and rel_parts[0] == ".system"),
    )


def iter_skills(skills_dir: Path) -> Iterable[Skill]:
    for skill_md in sorted(skills_dir.glob("*/SKILL.md")):
        skill = load_skill(skill_md, skills_dir)
        if skill:
            yield skill
    system_dir = skills_dir / ".system"
    if system_dir.exists():
        for skill_md in sorted(system_dir.glob("*/SKILL.md")):
            skill = load_skill(skill_md, skills_dir)
            if skill:
                yield skill


def cutoff_time(days: int) -> datetime:
    return datetime.now(timezone.utc) - timedelta(days=days)


def recent_session_files(sessions_dir: Path, days: int) -> list[Path]:
    if not sessions_dir.exists():
        return []
    cutoff = cutoff_time(days).timestamp()
    files: list[Path] = []
    for path in sessions_dir.rglob("*"):
        if path.is_file() and path.stat().st_mtime >= cutoff:
            files.append(path)
    return files


def scan_usage(skills: list[Skill], session_files: list[Path]) -> dict[str, int]:
    usage = {skill.name: 0 for skill in skills}
    if not session_files:
        return usage

    patterns = {
        skill.name: re.compile(
            r"(\$" + re.escape(skill.name) + r"\b|/skills/(?:\.system/)?"
            + re.escape(skill.name)
            + r"/SKILL\.md\b|name:\s*"
            + re.escape(skill.name)
            + r"\b)"
        )
        for skill in skills
    }
    for path in session_files:
        try:
            text = path.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        for name, pattern in patterns.items():
            matches = pattern.findall(text)
            if matches:
                usage[name] += len(matches)
    return usage


def disable_skill(skill: Skill, disabled_dir: Path) -> Path:
    disabled_dir.mkdir(parents=True, exist_ok=True)
    target = disabled_dir / skill.path.name
    if target.exists():
        stamp = datetime.now().strftime("%Y%m%d%H%M%S")
        target = disabled_dir / f"{skill.path.name}-{stamp}"
    shutil.move(str(skill.path), str(target))
    return target


def build_report(args: argparse.Namespace) -> dict:
    skills_dir = Path(args.skills_dir).expanduser().resolve()
    sessions_dir = Path(args.sessions_dir).expanduser().resolve()
    disabled_dir = Path(args.disabled_dir).expanduser().resolve()
    skills = list(iter_skills(skills_dir))
    session_files = recent_session_files(sessions_dir, args.days)
    usage = scan_usage(skills, session_files)
    budget = args.budget_tokens
    if budget is None and args.context_limit:
        budget = round(args.context_limit * 0.02)

    active_skills = [skill for skill in skills if not skill.is_system]
    total_tokens = sum(skill.approx_tokens for skill in active_skills)
    unused = [skill for skill in active_skills if usage.get(skill.name, 0) == 0]
    disabled: list[dict[str, str]] = []

    if args.disable_unused:
        for skill in unused:
            target = disable_skill(skill, disabled_dir)
            disabled.append({"name": skill.name, "target": str(target)})

    return {
        "skills_dir": str(skills_dir),
        "sessions_dir": str(sessions_dir),
        "session_files_scanned": len(session_files),
        "lookback_days": args.days,
        "budget_tokens": budget,
        "active_description_tokens": total_tokens,
        "budget_exceeded": bool(budget is not None and total_tokens > budget),
        "unused_skills": [skill.name for skill in unused],
        "disabled": disabled,
        "skills": [
            {
                "name": skill.name,
                "path": str(skill.path),
                "system": skill.is_system,
                "usage_hits": usage.get(skill.name, 0),
                "description_tokens": skill.approx_tokens,
                "description_chars": len(skill.description),
            }
            for skill in skills
        ],
        "warnings": [] if session_files else [f"No recent session files found in {sessions_dir}"],
    }


def print_text_report(report: dict) -> None:
    print(f"Skills dir: {report['skills_dir']}")
    print(f"Sessions dir: {report['sessions_dir']}")
    print(f"Session files scanned: {report['session_files_scanned']}")
    print(f"Lookback days: {report['lookback_days']}")
    budget = report["budget_tokens"]
    if budget is None:
        print("Description budget: unknown; pass --context-limit or --budget-tokens")
    else:
        status = "exceeded" if report["budget_exceeded"] else "within budget"
        print(
            f"Description budget: {report['active_description_tokens']} / "
            f"{budget} approx tokens ({status})"
        )
    if report["warnings"]:
        print("\nWarnings:")
        for warning in report["warnings"]:
            print(f"- {warning}")
    print("\nUnused active skills:")
    if report["unused_skills"]:
        for name in report["unused_skills"]:
            print(f"- {name}")
    else:
        print("- none")
    if report["disabled"]:
        print("\nDisabled skills:")
        for entry in report["disabled"]:
            print(f"- {entry['name']} -> {entry['target']}")
    print("\nSkill detail:")
    for skill in sorted(report["skills"], key=lambda item: (item["system"], item["name"])):
        marker = "system" if skill["system"] else "active"
        print(
            f"- {skill['name']} ({marker}): hits={skill['usage_hits']} "
            f"description_tokens={skill['description_tokens']}"
        )


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--skills-dir", default="~/.codex/skills")
    parser.add_argument("--sessions-dir", default="~/.codex/sessions")
    parser.add_argument("--disabled-dir", default="~/.codex/skills.disabled")
    parser.add_argument("--days", type=int, default=30)
    parser.add_argument("--context-limit", type=int)
    parser.add_argument("--budget-tokens", type=int)
    parser.add_argument("--disable-unused", action="store_true")
    parser.add_argument("--json", action="store_true", dest="json_output")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    report = build_report(args)
    if args.json_output:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print_text_report(report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
