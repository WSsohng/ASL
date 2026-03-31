#!/usr/bin/env python3
import argparse
import json
import os
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def check_publications():
    path = ROOT / "assets" / "publication-data.json"
    data = load_json(path)

    total = 0
    no_authors_marked = []
    weird_author_markers = []
    missing_local_images = []
    missing_pdf = []
    empty_image_records = []
    empty_image_records_modern = []
    data_uri_images = []
    external_images = []

    weird_chars = {"¢", "Ó", "â", "‡", "†", "�"}

    for year, records in data.items():
        for idx, record in enumerate(records, start=1):
            total += 1
            title = (record.get("title") or "").strip()
            authors_marked = record.get("authors_marked") or ""

            if not authors_marked.strip():
                no_authors_marked.append(
                    {"year": year, "index": idx, "title": title}
                )

            if any(ch in authors_marked for ch in weird_chars):
                weird_author_markers.append(
                    {
                        "year": year,
                        "index": idx,
                        "title": title,
                        "authors_marked": authors_marked,
                    }
                )

            images = record.get("images") or []
            if not images:
                item = {"year": year, "index": idx, "title": title}
                empty_image_records.append(item)
                start_year = int(year.split("-")[0]) if "-" in year else int(year)
                if start_year >= 2020:
                    empty_image_records_modern.append(item)

            for image in images:
                if not image:
                    continue
                if image.startswith("data:image/"):
                    data_uri_images.append(
                        {"year": year, "index": idx, "title": title, "image": image[:80]}
                    )
                    continue
                if image.startswith("http://") or image.startswith("https://"):
                    external_images.append(
                        {"year": year, "index": idx, "title": title, "image": image}
                    )
                    continue
                local_path = image[2:] if image.startswith("./") else image
                if not (ROOT / local_path).exists():
                    missing_local_images.append(
                        {"year": year, "index": idx, "title": title, "image": image}
                    )

            pdf = (record.get("pdf") or "").strip()
            if pdf:
                local_pdf = pdf[2:] if pdf.startswith("./") else pdf
                if not (ROOT / local_pdf).exists():
                    missing_pdf.append(
                        {"year": year, "index": idx, "title": title, "pdf": pdf}
                    )

    return {
        "total_records": total,
        "no_authors_marked": no_authors_marked,
        "weird_author_markers": weird_author_markers,
        "missing_local_images": missing_local_images,
        "missing_pdf": missing_pdf,
        "empty_image_records": empty_image_records,
        "empty_image_records_modern": empty_image_records_modern,
        "data_uri_images": data_uri_images,
        "external_images": external_images,
    }


def flatten_members(member_json):
    members = []
    for section in ("current", "alumni", "professor"):
        value = member_json.get(section, [])
        if isinstance(value, dict):
            value = [value]
        for item in value:
            members.append({"section": section, **item})
    return members


def check_members():
    path = ROOT / "assets" / "member-data.json"
    data = load_json(path)
    members = flatten_members(data)

    missing_images = []
    for person in members:
        image = (person.get("image") or person.get("photo") or "").strip()
        if not image:
            continue
        if image.startswith("http://") or image.startswith("https://"):
            continue
        local_path = image[2:] if image.startswith("./") else image
        if not (ROOT / local_path).exists():
            missing_images.append(
                {
                    "section": person.get("section"),
                    "name": person.get("name"),
                    "image": image,
                }
            )

    return {"total_records": len(members), "missing_images": missing_images}


def check_gallery():
    path = ROOT / "data" / "gallery_migration" / "gallery-data.runtime.json"
    data = load_json(path)

    empty_title = []
    empty_content = []
    empty_images = []
    unsupported_image_refs = []

    total_images = 0
    for item in data:
        post_id = str(item.get("id"))
        title = (item.get("title") or "").strip()
        content = (item.get("content") or "").strip()
        images = item.get("images") or []

        if not title:
            empty_title.append(post_id)
        if not content:
            empty_content.append(post_id)
        if not images:
            empty_images.append(post_id)

        for image in images:
            total_images += 1
            is_supabase = "supabase.co/storage" in image
            is_local_asset = isinstance(image, str) and (
                image.startswith("./assets/") or image.startswith("assets/")
            )
            if not is_supabase and not is_local_asset:
                unsupported_image_refs.append({"id": post_id, "image": image})

    return {
        "total_posts": len(data),
        "total_images": total_images,
        "empty_title_post_ids": empty_title,
        "empty_content_post_ids": empty_content,
        "empty_images_post_ids": empty_images,
        "unsupported_image_refs": unsupported_image_refs,
    }


def load_backfill_verification():
    path = ROOT / "data" / "gallery_migration" / "backfill_verify_report.json"
    if not path.exists():
        return {"available": False}
    report = load_json(path)
    report["available"] = True
    return report


def build_status(report):
    checks = []

    pub = report["publications"]
    gallery = report["gallery"]
    members = report["members"]
    backfill = report["supabase_backfill"]

    checks.append(
        {
            "name": "Publication local image paths",
            "status": "pass" if not pub["missing_local_images"] else "fail",
            "count": len(pub["missing_local_images"]),
        }
    )
    checks.append(
        {
            "name": "Publication PDF paths",
            "status": "pass" if not pub["missing_pdf"] else "fail",
            "count": len(pub["missing_pdf"]),
        }
    )
    checks.append(
        {
            "name": "Publication author-marker encoding",
            "status": "pass" if not pub["weird_author_markers"] else "warn",
            "count": len(pub["weird_author_markers"]),
        }
    )
    checks.append(
        {
            "name": "Publication empty graphical abstracts",
            "status": "pass" if not pub["empty_image_records_modern"] else "warn",
            "count": len(pub["empty_image_records_modern"]),
        }
    )
    checks.append(
        {
            "name": "Publication external/data-uri graphics",
            "status": "pass"
            if not pub["external_images"] and not pub["data_uri_images"]
            else "warn",
            "count": len(pub["external_images"]) + len(pub["data_uri_images"]),
        }
    )
    checks.append(
        {
            "name": "Member profile image paths",
            "status": "pass" if not members["missing_images"] else "fail",
            "count": len(members["missing_images"]),
        }
    )
    checks.append(
        {
            "name": "Gallery required fields",
            "status": "pass"
            if not gallery["empty_title_post_ids"] and not gallery["empty_images_post_ids"]
            else "fail",
            "count": len(gallery["empty_title_post_ids"]) + len(gallery["empty_images_post_ids"]),
        }
    )
    checks.append(
        {
            "name": "Gallery content completeness",
            "status": "pass" if not gallery["empty_content_post_ids"] else "warn",
            "count": len(gallery["empty_content_post_ids"]),
        }
    )
    checks.append(
        {
            "name": "Gallery image refs supported (Supabase or local assets)",
            "status": "pass" if not gallery["unsupported_image_refs"] else "warn",
            "count": len(gallery["unsupported_image_refs"]),
        }
    )
    checks.append(
        {
            "name": "Supabase backfill parity (latest report)",
            "status": "pass" if backfill.get("available") and backfill.get("ok") else "warn",
            "count": 0,
        }
    )

    overall = "pass"
    if any(c["status"] == "fail" for c in checks):
        overall = "fail"
    elif any(c["status"] == "warn" for c in checks):
        overall = "warn"

    return {"overall": overall, "checks": checks}


def main():
    parser = argparse.ArgumentParser(
        description="Run ASL full data-integrity checks and emit a consolidated report."
    )
    parser.add_argument(
        "--out",
        default=str(ROOT / "_analysis" / "full_integrity_report.json"),
        help="Output report path (JSON).",
    )
    args = parser.parse_args()

    report = {
        "publications": check_publications(),
        "members": check_members(),
        "gallery": check_gallery(),
        "supabase_backfill": load_backfill_verification(),
    }
    report["status"] = build_status(report)

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with out_path.open("w", encoding="utf-8") as f:
        json.dump(report, f, ensure_ascii=False, indent=2)

    print(json.dumps({"out": str(out_path), "overall": report["status"]["overall"]}, ensure_ascii=False))


if __name__ == "__main__":
    main()
