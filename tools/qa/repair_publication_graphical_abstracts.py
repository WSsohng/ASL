#!/usr/bin/env python3
from __future__ import annotations

import argparse
import base64
import json
import hashlib
import re
from difflib import SequenceMatcher
from io import BytesIO
from pathlib import Path
from typing import Any

from bs4 import BeautifulSoup
from PIL import Image


ROOT = Path(__file__).resolve().parents[2]
PUBLICATION_JSON = ROOT / "assets" / "publication-data.json"
PUBLICATION_YEARS_DIR = ROOT / "publication-years"
REPORT_PATH = ROOT / "_analysis" / "publication_graphical_repair_report.json"
KNOWN_PDF_ICON_HASHES = {
    # 400x400 red PDF icon used in legacy page as "PDF button image"
    "a7bd93c6d5de33db15c9c80ef2ddf76bbe7939fc7fa32879a36b13957a04c187",
    # tiny 57x57 inline PDF icon from some legacy pages
    "20b34f08d0cf95dc89bd39f3304b0fedea3f6f636de53e9697d8ab5726576659",
    # another tiny local icon
    "d392c2b5c5dab276c63a48c17ac3c8e16a3373d86b73b69736e673dbc09b29c3",
}


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def save_json(path: Path, data: Any) -> None:
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")


def year_start(group: str) -> int:
    m = re.search(r"(19|20)\d{2}", group or "")
    return int(m.group(0)) if m else 0


def normalize_text(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", " ", (value or "").lower()).strip()


def tokenize(value: str) -> set[str]:
    return {t for t in normalize_text(value).split() if len(t) > 2}


def has_valid_graphical(images: list[str]) -> bool:
    for src in images or []:
        if is_graphical_candidate(src):
            return True
    return False


def is_graphical_candidate(src: str) -> bool:
    s = (src or "").strip()
    if not s:
        return False
    l = s.lower()
    if "publication-placeholder" in l or "no-graphical-abstract" in l:
        return False
    if "icon_pdf" in l or "pdficon" in l or "download.php?user_file" in l:
        return False
    if "aaal1619487999_1.jpg" in l:
        return False
    if l.startswith("data:image/"):
        m = re.match(r"^data:image/([a-zA-Z0-9.+-]+);base64,(.+)$", s, flags=re.IGNORECASE | re.DOTALL)
        if not m:
            return False
        try:
            raw = base64.b64decode(m.group(2).strip())
            digest = hashlib.sha256(raw).hexdigest()
            if digest in KNOWN_PDF_ICON_HASHES:
                return False
            with Image.open(BytesIO(raw)) as im:
                w, h = im.size
            # legacy PDF icons are tiny; graphical abstracts are usually much larger
            if w < 220 or h < 140:
                return False
            return True
        except Exception:
            return False
    if l.endswith(".pdf"):
        return False
    if s.startswith("./"):
        p = ROOT / s[2:]
        if p.exists() and p.is_file():
            try:
                digest = hashlib.sha256(p.read_bytes()).hexdigest()
                if digest in KNOWN_PDF_ICON_HASHES:
                    return False
            except Exception:
                pass
    if s.startswith("assets/"):
        p = ROOT / s
        if p.exists() and p.is_file():
            try:
                digest = hashlib.sha256(p.read_bytes()).hexdigest()
                if digest in KNOWN_PDF_ICON_HASHES:
                    return False
            except Exception:
                pass
    return True


def slugify_title(title: str, max_len: int = 120) -> str:
    base = re.sub(r"[^a-z0-9]+", "-", normalize_text(title)).strip("-")
    return (base or "graphical-abstract")[:max_len]


def decode_data_uri_to_file(data_uri: str, year: str, title: str, write_files: bool) -> str:
    m = re.match(r"^data:image/([a-zA-Z0-9.+-]+);base64,(.+)$", data_uri, flags=re.IGNORECASE | re.DOTALL)
    if not m:
        return ""
    ext = m.group(1).lower()
    if ext == "jpeg":
        ext = "jpg"
    raw = m.group(2).strip()
    out_dir = ROOT / "assets" / "publications" / "recovered" / str(year)
    name = f"{slugify_title(title)}.{ext}"
    out_path = out_dir / name
    try:
        raw_bytes = base64.b64decode(raw)
        if hashlib.sha256(raw_bytes).hexdigest() in KNOWN_PDF_ICON_HASHES:
            return ""
        with Image.open(BytesIO(raw_bytes)) as im:
            w, h = im.size
        if w < 220 or h < 140:
            return ""
        rel = out_path.relative_to(ROOT).as_posix()
        if write_files:
            out_dir.mkdir(parents=True, exist_ok=True)
            out_path.write_bytes(raw_bytes)
        return f"./{rel}"
    except Exception:
        return ""


def extract_candidate_from_year_html(year: str, title: str, write_files: bool) -> str:
    html_path = PUBLICATION_YEARS_DIR / f"{year}.html"
    if not html_path.exists():
        return ""
    html = html_path.read_text(encoding="utf-8", errors="ignore")
    soup = BeautifulSoup(html, "html.parser")

    title_tokens = tokenize(title)
    if not title_tokens:
        return ""

    candidates: list[tuple[float, Any, str]] = []
    for node in soup.find_all(["p", "h1", "h2", "h3", "span", "font", "b"]):
        text = node.get_text(" ", strip=True)
        if not text or len(text) < 24:
            continue
        nt = normalize_text(text)
        if not nt:
            continue
        node_tokens = {t for t in nt.split() if len(t) > 2}
        if not node_tokens:
            continue
        overlap = len(title_tokens & node_tokens) / max(1, len(title_tokens))
        if overlap < 0.35:
            continue
        ratio = SequenceMatcher(None, normalize_text(title), nt).ratio()
        score = overlap * 0.7 + ratio * 0.3
        candidates.append((score, node, text))

    if not candidates:
        return ""
    candidates.sort(key=lambda x: x[0], reverse=True)
    anchor = candidates[0][1]

    # collect images from anchor and following nodes (until a new likely numbered section starts)
    img_srcs: list[str] = []
    scan_count = 0
    for nxt in anchor.find_all_next():
        scan_count += 1
        if scan_count > 420:
            break
        name = getattr(nxt, "name", "")
        if name in ("b", "strong"):
            txt = (nxt.get_text(" ", strip=True) or "").strip()
            if re.fullmatch(r"\d{1,2}", txt):
                break
        if name == "img":
            src = (nxt.get("src") or "").strip()
            if src:
                img_srcs.append(src)

    for src in img_srcs:
        if not is_graphical_candidate(src):
            continue
        if src.lower().startswith("data:image/"):
            extracted = decode_data_uri_to_file(src, year, title, write_files=write_files)
            if extracted:
                return extracted
            continue
        if src.startswith("./") and (ROOT / src[2:]).exists():
            return src
        if src.startswith("assets/") and (ROOT / src).exists():
            return f"./{src}"
        # keep external URL if that's all we have
        return src
    return ""


def main() -> int:
    parser = argparse.ArgumentParser(description="Repair missing/placeholder publication graphical abstracts from year HTML.")
    parser.add_argument("--write", action="store_true", help="Write fixes into assets/publication-data.json")
    parser.add_argument("--report", default=str(REPORT_PATH), help="Report output path")
    args = parser.parse_args()

    data = load_json(PUBLICATION_JSON)
    report: dict[str, Any] = {
        "scanned_years": "2012-2026",
        "total_candidates": 0,
        "repaired": [],
        "unresolved": [],
    }

    for year_group, rows in data.items():
        ys = year_start(year_group)
        if ys < 2012 or ys > 2026:
            continue
        year = str(ys)
        for idx, row in enumerate(rows, start=1):
            title = (row.get("title") or "").strip()
            images = row.get("images") or []
            if has_valid_graphical(images):
                continue
            report["total_candidates"] += 1
            found = extract_candidate_from_year_html(year, title, write_files=bool(args.write))
            if found:
                report["repaired"].append(
                    {"year_group": year_group, "index": idx, "title": title, "image": found}
                )
                row["images"] = [found]
            else:
                report["unresolved"].append(
                    {"year_group": year_group, "index": idx, "title": title, "existing_images": images}
                )

    out = Path(args.report)
    out.parent.mkdir(parents=True, exist_ok=True)
    save_json(out, report)

    if args.write and report["repaired"]:
        save_json(PUBLICATION_JSON, data)

    print(
        json.dumps(
            {
                "report": str(out),
                "total_candidates": report["total_candidates"],
                "repaired": len(report["repaired"]),
                "unresolved": len(report["unresolved"]),
                "write": bool(args.write),
            },
            ensure_ascii=False,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
