#!/bin/bash
# Build MyDU-ArchHUD.conf and pack deploy/MyDU-ArchHUD.zip (conf + archhud/ module tree).
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ROOTDIR="$(dirname "$DIR")"
DEPLOY="${ROOTDIR}/deploy"
MINIFY="${1:-false}"

export HUD_DISPLAY_NAME="MyDU ArchHUD"
"${DIR}/wrap.sh" "$MINIFY" "${ROOTDIR}/src/ArchHUD.lua" "${ROOTDIR}/MyDU-ArchHUD.conf"

rm -rf "$DEPLOY"
mkdir -p "${DEPLOY}/archhud/custom"

cp "${ROOTDIR}/MyDU-ArchHUD.conf" "${DEPLOY}/"
cp "${ROOTDIR}/src/requires/"*.lua "${DEPLOY}/archhud/"
cp "${ROOTDIR}/src/requires/custom/mydu_atlas.lua" "${DEPLOY}/archhud/custom/"

(
  cd "$DEPLOY"
  rm -f "${ROOTDIR}/MyDU-ArchHUD.zip"
  zip -rq "${ROOTDIR}/MyDU-ArchHUD.zip" .
)

echo "Packed ${ROOTDIR}/MyDU-ArchHUD.zip ($(du -h "${ROOTDIR}/MyDU-ArchHUD.zip" | cut -f1))"
