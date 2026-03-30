from __future__ import annotations

from pathlib import Path
from PIL import Image, ImageOps

Image.MAX_IMAGE_PIXELS = None

ROOT = Path(__file__).resolve().parents[2]
SRC_ROOT = ROOT / "assets" / "gallery" / "imported"
OUT_ROOT = ROOT / "assets" / "gallery" / "thumbs"

# Card-like ratio used in gallery list
TARGET_W = 920
TARGET_H = 560
QUALITY = 70


def make_thumb(src_path: Path, out_path: Path) -> None:
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with Image.open(src_path) as im:
        rgb = im.convert("RGB")
        fitted = ImageOps.fit(rgb, (TARGET_W, TARGET_H), method=Image.Resampling.LANCZOS, centering=(0.5, 0.5))
        fitted.save(out_path, format="WEBP", quality=QUALITY, method=6)


def main() -> int:
    if not SRC_ROOT.exists():
        print(f"Source folder not found: {SRC_ROOT}")
        return 1

    count = 0
    skipped = 0
    for src in SRC_ROOT.rglob("*"):
        if not src.is_file():
            continue
        if src.suffix.lower() not in {".jpg", ".jpeg", ".png", ".webp", ".gif"}:
            continue
        rel = src.relative_to(SRC_ROOT)
        out = (OUT_ROOT / rel).with_suffix(".webp")
        try:
            make_thumb(src, out)
            count += 1
        except Exception:
            skipped += 1

    print(f"[done] generated thumbnails: {count}, skipped: {skipped}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
