#!/usr/bin/env python3
"""Scrape Colorado daily forecast text from kodythewxguy.com."""

from __future__ import annotations

import argparse
import datetime as dt
import html
import json
import re
import sys
from html.parser import HTMLParser
from typing import List, Tuple
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

DEFAULT_URL = "https://kodythewxguy.com/colorado-daily-weather-forecast/"
USER_AGENT = "Mozilla/5.0"
PROMOTIONAL_PREFIXES = (
    "Thank you to ",
    "Thank you for sponsoring ",
    "PLEASE SUPPORT LOCAL",
)


def normalize_text(value: str) -> str:
    value = html.unescape(value).replace("\xa0", " ")
    value = value.replace("\r\n", "\n").replace("\r", "\n")
    lines = []
    for line in value.split("\n"):
        compact = " ".join(line.split())
        if compact:
            lines.append(compact)
    return "\n".join(lines).strip()


class ForecastContentParser(HTMLParser):
    """Extract headings, paragraphs, and image URLs from forecast content HTML."""

    CAPTURE_TAGS = {"h2", "h3", "p", "li"}

    def __init__(self) -> None:
        super().__init__()
        self.entries: List[Tuple[str, str]] = []
        self.image_urls: List[str] = []
        self._current_tag: str | None = None
        self._buffer: List[str] = []

    def handle_starttag(self, tag: str, attrs: List[Tuple[str, str | None]]) -> None:
        attrs_dict = dict(attrs)

        if tag in self.CAPTURE_TAGS:
            if self._current_tag is not None:
                self._finalize_current()
            self._current_tag = tag
            self._buffer = []
            return

        if tag == "br" and self._current_tag is not None:
            self._buffer.append("\n")
            return

        if tag == "img":
            src = attrs_dict.get("src")
            if src and src not in self.image_urls:
                self.image_urls.append(src)

    def handle_endtag(self, tag: str) -> None:
        if self._current_tag == tag:
            self._finalize_current()

    def handle_data(self, data: str) -> None:
        if self._current_tag is not None:
            self._buffer.append(data)

    def _finalize_current(self) -> None:
        text = normalize_text("".join(self._buffer))
        if text:
            self.entries.append((self._current_tag or "", text))
        self._current_tag = None
        self._buffer = []


def fetch_html(url: str, timeout: int) -> str:
    request = Request(url, headers={"User-Agent": USER_AGENT})
    with urlopen(request, timeout=timeout) as response:  # nosec: B310
        return response.read().decode("utf-8", "replace")


def extract_balanced_div(document: str, open_div_index: int) -> tuple[str, int]:
    open_tag_end = document.find(">", open_div_index)
    if open_tag_end == -1:
        raise ValueError("Unterminated opening div tag in document")

    depth = 1
    for match in re.finditer(r"<div\b|</div>", document[open_tag_end + 1 :], flags=re.IGNORECASE):
        token = match.group(0).lower()
        absolute_start = open_tag_end + 1 + match.start()
        if token == "<div":
            depth += 1
            continue

        depth -= 1
        if depth == 0:
            close_tag_end = document.find(">", absolute_start)
            if close_tag_end == -1:
                raise ValueError("Unterminated closing div tag in document")
            inner_html = document[open_tag_end + 1 : absolute_start]
            return inner_html, close_tag_end + 1

    raise ValueError("Matching closing div tag not found")


def extract_forecast_container_html(document: str) -> str:
    widget_marker = "elementor-widget-theme-post-content"
    widget_index = document.find(widget_marker)
    if widget_index == -1:
        raise ValueError("Forecast widget marker not found in page")

    container_class = 'class="elementor-widget-container"'
    container_class_index = document.find(container_class, widget_index)
    if container_class_index == -1:
        raise ValueError("Forecast content container not found in page")

    open_div_index = document.rfind("<div", 0, container_class_index)
    if open_div_index == -1:
        raise ValueError("Container opening div not found in page")

    inner_html, _ = extract_balanced_div(document, open_div_index)
    return inner_html


def parse_forecast(document: str) -> dict:
    container_html = extract_forecast_container_html(document)

    parser = ForecastContentParser()
    parser.feed(container_html)
    parser.close()

    date_match = re.search(r'"datePublished":"([^"]+)"', document)
    page_title_match = re.search(r"<title>(.*?)</title>", document, flags=re.IGNORECASE | re.DOTALL)

    headings_h2 = [text for tag, text in parser.entries if tag == "h2"]
    headings_h3 = [text for tag, text in parser.entries if tag == "h3"]
    paragraphs = [text for tag, text in parser.entries if tag in {"p", "li"}]

    return {
        "page_title": normalize_text(page_title_match.group(1)) if page_title_match else None,
        "published_at": date_match.group(1) if date_match else None,
        "forecast_date": headings_h2[0] if headings_h2 else None,
        "headline": headings_h3[0] if headings_h3 else None,
        "paragraphs": paragraphs,
        "image_urls": parser.image_urls,
    }


def trim_paragraphs(
    paragraphs: List[str],
    max_paragraphs: int,
    include_promotional: bool,
) -> List[str]:
    cleaned: List[str] = []

    for paragraph in paragraphs:
        if not include_promotional and paragraph.startswith(PROMOTIONAL_PREFIXES):
            break
        cleaned.append(paragraph)

    if max_paragraphs > 0:
        cleaned = cleaned[:max_paragraphs]
    return cleaned


def format_text_output(payload: dict) -> str:
    lines = [
        f"Source: {payload['source_url']}",
        f"Fetched (UTC): {payload['fetched_at_utc']}",
    ]

    if payload.get("published_at"):
        lines.append(f"Published: {payload['published_at']}")
    if payload.get("forecast_date"):
        lines.append(f"Forecast date: {payload['forecast_date']}")
    if payload.get("headline"):
        lines.append(f"Headline: {payload['headline']}")

    image_urls = payload.get("image_urls") or []
    if image_urls:
        lines.append(f"Map images: {len(image_urls)}")
        lines.extend(f"- {url}" for url in image_urls)

    lines.append("Forecast details:")
    paragraphs = payload.get("paragraphs") or []
    if not paragraphs:
        lines.append("- (no forecast paragraphs extracted)")
    else:
        lines.extend(f"- {paragraph}" for paragraph in paragraphs)

    return "\n".join(lines)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Scrape Colorado daily weather forecast from kodythewxguy.com."
    )
    parser.add_argument("--url", default=DEFAULT_URL, help="Forecast page URL to scrape.")
    parser.add_argument(
        "--timeout",
        type=int,
        default=30,
        help="HTTP timeout in seconds (default: 30).",
    )
    parser.add_argument(
        "--max-paragraphs",
        type=int,
        default=8,
        help="Maximum forecast paragraphs to include (0 for all).",
    )
    parser.add_argument(
        "--include-promotional",
        action="store_true",
        help="Include sponsor/promotional paragraphs at the end of the post.",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Emit JSON output instead of human-readable text.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    fetched_at = dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat()

    try:
        document = fetch_html(args.url, args.timeout)
        parsed = parse_forecast(document)
    except HTTPError as exc:
        print(f"HTTP error while fetching forecast: {exc.code} {exc.reason}", file=sys.stderr)
        return 2
    except URLError as exc:
        print(f"Network error while fetching forecast: {exc.reason}", file=sys.stderr)
        return 2
    except ValueError as exc:
        print(f"Parsing error: {exc}", file=sys.stderr)
        return 3

    parsed["paragraphs"] = trim_paragraphs(
        parsed.get("paragraphs", []),
        max_paragraphs=max(0, args.max_paragraphs),
        include_promotional=args.include_promotional,
    )

    payload = {
        "source_url": args.url,
        "fetched_at_utc": fetched_at,
        **parsed,
    }

    if args.json:
        print(json.dumps(payload, indent=2))
    else:
        print(format_text_output(payload))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
