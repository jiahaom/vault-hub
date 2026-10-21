#!/usr/bin/env python3
"""Rebuild the file index embedded in index.html.

Run this after adding, renaming or removing files in the project:
    python3 _hub/update_index.py

Each entry is [path, size, thumbnail id]; the id is "" when _hub/thumbs has no
picture for that file (the hub then shows a plain icon).
"""
import hashlib
import json
import os
import pathlib
import re
import unicodedata

ROOT = pathlib.Path(__file__).resolve().parent.parent
INDEX = ROOT / "index.html"
THUMBS = ROOT / "_hub" / "thumbs"
SKIP = {"_hub", "_Print Jobs"}
EXTENSIONS = {".stl", ".3mf", ".step", ".stp", ".obj", ".pdf", ".png", ".jpg", ".jpeg"}

files = []
for dirpath, dirnames, filenames in os.walk(ROOT):
    dirnames[:] = sorted(d for d in dirnames if not d.startswith(".") and d not in SKIP)
    for name in sorted(filenames):
        path = pathlib.Path(dirpath, name)
        if path.suffix.lower() not in EXTENSIONS:
            continue
        rel = unicodedata.normalize("NFC", path.relative_to(ROOT).as_posix())
        thumb = hashlib.sha1(rel.encode("utf-8")).hexdigest()[:16]
        files.append([rel, path.stat().st_size, thumb if (THUMBS / f"{thumb}.webp").exists() else ""])

payload = json.dumps(files, ensure_ascii=False, separators=(",", ":")).replace("</", "<\\/")
html = INDEX.read_text(encoding="utf-8")
pattern = re.compile(r'(<script id="manifest" type="application/json">)(.*?)(</script>)', re.S)
if not pattern.search(html):
    raise SystemExit("Could not find the manifest block in index.html")
INDEX.write_text(pattern.sub(lambda m: m.group(1) + payload + m.group(3), html, count=1), encoding="utf-8")
print(f"Indexed {len(files)} files into {INDEX.name}")
