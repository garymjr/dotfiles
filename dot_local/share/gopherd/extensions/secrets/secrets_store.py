#!/usr/bin/env python3
import argparse
import json
import os
import sqlite3
import sys
import time
from typing import Any, Optional


def ensure_schema(conn: sqlite3.Connection) -> None:
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS secrets (
            name TEXT PRIMARY KEY,
            value TEXT NOT NULL,
            updated_at INTEGER NOT NULL
        )
        """
    )
    conn.commit()


def create_connection(db_path: str) -> sqlite3.Connection:
    parent_dir = os.path.dirname(db_path)
    if parent_dir:
        os.makedirs(parent_dir, exist_ok=True)

    existed = os.path.exists(db_path)
    conn = sqlite3.connect(db_path, timeout=5)
    ensure_schema(conn)

    if not existed:
        try:
            os.chmod(db_path, 0o600)
        except OSError:
            pass

    return conn


def set_secret(conn: sqlite3.Connection, name: str, value: str) -> dict[str, Any]:
    now = int(time.time())
    conn.execute(
        """
        INSERT INTO secrets (name, value, updated_at)
        VALUES (?, ?, ?)
        ON CONFLICT(name) DO UPDATE SET
            value = excluded.value,
            updated_at = excluded.updated_at
        """,
        (name, value, now),
    )
    conn.commit()
    return {"ok": True, "action": "set", "key": name, "updated_at": now}


def get_secret(conn: sqlite3.Connection, name: str) -> dict[str, Any]:
    row = conn.execute(
        "SELECT value, updated_at FROM secrets WHERE name = ?",
        (name,),
    ).fetchone()

    if row is None:
        return {"ok": True, "action": "get", "key": name, "found": False}

    return {
        "ok": True,
        "action": "get",
        "key": name,
        "found": True,
        "value": row[0],
        "updated_at": row[1],
    }


def delete_secret(conn: sqlite3.Connection, name: str) -> dict[str, Any]:
    cur = conn.execute("DELETE FROM secrets WHERE name = ?", (name,))
    conn.commit()
    return {
        "ok": True,
        "action": "delete",
        "key": name,
        "deleted": cur.rowcount > 0,
    }


def escape_like(value: str) -> str:
    return value.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")


def list_secrets(conn: sqlite3.Connection, prefix: Optional[str]) -> dict[str, Any]:
    if prefix:
        pattern = f"{escape_like(prefix)}%"
        rows = conn.execute(
            "SELECT name FROM secrets WHERE name LIKE ? ESCAPE '\\' ORDER BY name ASC",
            (pattern,),
        ).fetchall()
    else:
        rows = conn.execute("SELECT name FROM secrets ORDER BY name ASC").fetchall()

    return {
        "ok": True,
        "action": "list",
        "keys": [row[0] for row in rows],
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="SQLite-backed secret store")
    parser.add_argument("--db", required=True, help="Path to sqlite database file")
    parser.add_argument(
        "--op",
        required=True,
        choices=("set", "get", "delete", "list"),
        help="Operation name",
    )
    parser.add_argument("--key", help="Secret key (required for set/get/delete)")
    parser.add_argument("--value", help="Secret value (required for set)")
    parser.add_argument("--prefix", help="Optional key prefix filter for list")

    args = parser.parse_args()

    if args.op in ("set", "get", "delete") and not args.key:
        parser.error(f'--key is required when --op is "{args.op}"')
    if args.op == "set" and args.value is None:
        parser.error('--value is required when --op is "set"')

    return args


def run() -> int:
    args = parse_args()
    conn = create_connection(args.db)
    try:
        if args.op == "set":
            result = set_secret(conn, args.key, args.value)
        elif args.op == "get":
            result = get_secret(conn, args.key)
        elif args.op == "delete":
            result = delete_secret(conn, args.key)
        elif args.op == "list":
            result = list_secrets(conn, args.prefix)
        else:
            raise RuntimeError(f"unsupported operation: {args.op}")
    finally:
        conn.close()

    sys.stdout.write(json.dumps(result, ensure_ascii=True))
    sys.stdout.write("\n")
    return 0


def main() -> int:
    try:
        return run()
    except Exception as exc:  # pragma: no cover
        print(f"secrets store error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
