#!/bin/bash
# Build modular zip and GFN-style conf (atlas inlined in conf; other modules still in archhud/).
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOTDIR="$(dirname "$DIR")"
MINIFY="${1:-false}"

echo "=== Modular MyDU ArchHUD (conf + archhud/ zip) ==="
"${DIR}/deploy-pack.sh" "$MINIFY"

echo "=== GFN-style MyDU ArchHUD (atlas inlined in conf) ==="
"${DIR}/inline-atlas.sh"
export HUD_DISPLAY_NAME="MyDU ArchHUD GFN"
"${DIR}/wrap.sh" "$MINIFY" \
  "${ROOTDIR}/build/ArchHUD.inlined.lua" \
  "${ROOTDIR}/MyDU-ArchHUD-GFN.conf"

echo "Done:"
echo "  ${ROOTDIR}/MyDU-ArchHUD.conf"
echo "  ${ROOTDIR}/MyDU-ArchHUD.zip"
echo "  ${ROOTDIR}/MyDU-ArchHUD-GFN.conf"
