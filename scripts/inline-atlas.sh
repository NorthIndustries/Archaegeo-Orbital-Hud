#!/bin/bash
# Produce a copy of ArchHUD.lua with mydu_atlas inlined (no separate atlas require file).
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOTDIR="$(dirname "$DIR")"
BUILD_DIR="${ROOTDIR}/build"
ATLAS="${ROOTDIR}/src/requires/custom/mydu_atlas.lua"
SRC="${ROOTDIR}/src/ArchHUD.lua"
OUT="${BUILD_DIR}/ArchHUD.inlined.lua"

mkdir -p "$BUILD_DIR"

python3 <<PY
from pathlib import Path

atlas_path = Path("${ATLAS}")
src_path = Path("${SRC}")
out_path = Path("${OUT}")

atlas_lines = atlas_path.read_text(encoding="utf-8").splitlines()
while atlas_lines and (
    not atlas_lines[0].strip()
    or atlas_lines[0].lstrip().startswith("--")
):
    atlas_lines.pop(0)

body = "\n".join(atlas_lines).strip()
if body.startswith("return"):
    body = body[len("return"):].strip()
if not body.startswith("{"):
    raise SystemExit("Expected atlas module to return a table literal")

src = src_path.read_text(encoding="utf-8")
needle = 'local atlas = require("autoconf/custom/archhud/custom/mydu_atlas")'
replacement = f"local atlas = {body}"
if needle not in src:
    raise SystemExit(f"Missing atlas require line in {src_path}")

out_path.write_text(src.replace(needle, replacement, 1), encoding="utf-8")
print(f"Wrote {out_path} ({out_path.stat().st_size} bytes)")
PY
