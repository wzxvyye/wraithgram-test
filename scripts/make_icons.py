#!/usr/bin/env python3
"""Режет исходную картинку 1024x1024 в PNG-иконки, которые понимает iOS
без asset catalog (CFBundleIconFiles).

Запуск на Windows/macOS:
    python scripts/make_icons.py [путь-к-картинке]

По умолчанию берёт tools/wraithgram-icon.png из проекта wraithGram.
"""
from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "App" / "Icon"

DEFAULT_SOURCE = Path(r"D:\Users\wzxvyye\Desktop\wraithGram\tools\wraithgram-icon.png")

# (имя файла в бандле, сторона в пикселях)
ICONS = [
    ("Icon20x20@2x.png", 40),
    ("Icon20x20@3x.png", 60),
    ("Icon29x29@2x.png", 58),
    ("Icon29x29@3x.png", 87),
    ("Icon40x40@2x.png", 80),
    ("Icon40x40@3x.png", 120),
    ("Icon60x60@2x.png", 120),
    ("Icon60x60@3x.png", 180),
    ("Icon76x76@2x.png", 152),
    ("Icon83.5x83.5@2x.png", 167),
    ("Icon1024.png", 1024),
]


def main() -> int:
    source = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_SOURCE
    if not source.exists():
        print(f"Нет файла: {source}")
        return 1

    img = Image.open(source)
    if img.mode != "RGB":
        img = img.convert("RGB")
    if img.size != (1024, 1024):
        img = img.resize((1024, 1024), Image.LANCZOS)

    OUT.mkdir(parents=True, exist_ok=True)
    for name, size in ICONS:
        icon = img if size == 1024 else img.resize((size, size), Image.LANCZOS)
        icon.save(OUT / name, "PNG", optimize=True)
        print(f"  {name:26} {size}x{size}")

    print(f"OK: {len(ICONS)} иконок в {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
