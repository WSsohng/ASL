#!/usr/bin/env python3
"""Enrich gallery JSON title/content directly from legacy detail pages."""

from __future__ import annotations

import argparse
import json
import re
import time
from pathlib import Path

import requests
from bs4 import BeautifulSoup

USER_AGENT = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/122.0.0.0 Safari/537.36 ASL-Gallery-JSON-Enricher/1.0"
)


def fetch_html(session: requests.Session, url: str, timeout: int, retries: int = 3) -> str:
    last = None
    for i in range(retries):
        try:
            resp = session.get(url, timeout=timeout)
            resp.raise_for_status()
            if not resp.encoding or resp.encoding.lower() in {"iso-8859-1", "ascii"}:
                resp.encoding = "euc-kr"
            return resp.text
        except Exception as exc:  # noqa: BLE001
            last = exc
            time.sleep(0.2 * (i + 1))
    raise RuntimeError(f"fetch failed: {url} | {last}")


def extract_fields(html: str, title: str) -> tuple[str, str]:
    soup = BeautifulSoup(html, "html.parser")
    for tag in soup(["script", "style", "noscript"]):
        tag.decompose()

    title_norm = re.sub(r"\s+", " ", (title or "")).strip()
    raw_lines = [re.sub(r"\s+", " ", x).strip() for x in soup.get_text("\n", strip=True).splitlines()]
    lines: list[str] = []
    for line in raw_lines:
        if line and line not in lines:
            lines.append(line)

    nav_like = {
        "Professor",
        "Research",
        "Research Field",
        "|",
        "Publication",
        "Member",
        "Lecture",
        "Experiment",
        "Gallery",
        "리스트",
    }
    stop_keywords = ("COPYRIGHT", "한양대 ASL 분광분석연구실", "Analytical Spectroscopy Laboratory")
    blocked_contains = (
        "Professor Research",
        "Research Field | Publication",
        "Lecture | Experiment",
        "Professor Research Member Lecture Gallery",
        "Gallery",
        "이름 :",
        "등록일",
    )

    meta_idx = None
    for i, line in enumerate(lines):
        if ("이름 :" in line) or ("등록일" in line):
            meta_idx = i
            break

    extracted_title = title_norm
    if meta_idx is not None:
        for j in range(meta_idx - 1, -1, -1):
            cand = lines[j].strip()
            if (
                cand
                and cand not in nav_like
                and "분광분석연구실" not in cand
                and "Analytical Spectroscopy Laboratory" not in cand
                and "COPYRIGHT" not in cand.upper()
            ):
                extracted_title = cand
                break

    start_idx = (meta_idx + 1) if meta_idx is not None else 0
    picked: list[str] = []
    for line in lines[start_idx:]:
        low = line.lower()
        if any(k in line for k in stop_keywords):
            break
        if (
            not line
            or len(line) < 6
            or len(line) > 500
            or line == title_norm
            or line == extracted_title
            or low in {"content", "컨텐츠 바로가기"}
            or any(k.lower() in low for k in blocked_contains)
        ):
            continue
        picked.append(line)

    body = "\n\n".join(picked[:6]).strip()
    if not body and extracted_title and extracted_title != "컨텐츠 바로가기":
        body = extracted_title
    return extracted_title, body


def main() -> int:
    parser = argparse.ArgumentParser(description="Enrich gallery runtime JSON content/title")
    parser.add_argument("--json", default="data/gallery_migration/gallery-data.runtime.json")
    parser.add_argument("--out", default="")
    parser.add_argument("--timeout", type=int, default=20)
    parser.add_argument("--limit", type=int, default=0)
    args = parser.parse_args()

    in_path = Path(args.json)
    if not in_path.exists():
        raise SystemExit(f"JSON not found: {in_path}")
    out_path = Path(args.out) if args.out else in_path

    data = json.load(in_path.open("r", encoding="utf-8"))

    session = requests.Session()
    session.trust_env = False
    session.headers.update({"User-Agent": USER_AGENT})

    targets = []
    for post in data:
        title = (post.get("title") or "").strip()
        content = (post.get("content") or "").strip()
        source_url = (post.get("source_url") or "").strip()
        if source_url and ((not content) or title == "컨텐츠 바로가기" or not title):
            targets.append(post)

    if args.limit and args.limit > 0:
        targets = targets[: args.limit]

    ok = 0
    fail = 0
    for post in targets:
        try:
            html = fetch_html(session, post["source_url"], args.timeout)
            new_title, body = extract_fields(html, post.get("title", ""))
            if (not (post.get("title") or "").strip()) or (post.get("title") == "컨텐츠 바로가기"):
                if new_title and new_title != "컨텐츠 바로가기":
                    post["title"] = new_title
            if not (post.get("content") or "").strip():
                post["content"] = body
            ok += 1
        except Exception as exc:  # noqa: BLE001
            print(f"[warn] {post.get('id')} {post.get('source_url')} :: {exc}")
            fail += 1

    with out_path.open("w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"[done] targets={len(targets)} ok={ok} fail={fail} out={out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
