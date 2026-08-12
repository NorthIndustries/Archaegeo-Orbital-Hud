#!/bin/bash
# Static checks without requiring lua (CI runs full build-mydu.sh).
set -e

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "$ROOT"

echo "Checking atlas module..."
test -f src/requires/custom/mydu_atlas.lua
grep -q 'return {' src/requires/custom/mydu_atlas.lua

echo "Checking ArchHUD.lua uses bundled atlas..."
grep -q 'require("autoconf/custom/archhud/custom/mydu_atlas")' src/ArchHUD.lua
if grep -q 'require("atlas")' src/ArchHUD.lua; then
  echo "ERROR: src/ArchHUD.lua still requires global atlas" >&2
  exit 1
fi

echo "Checking inline-atlas..."
./scripts/inline-atlas.sh
grep -q 'local atlas = {' build/ArchHUD.inlined.lua
if grep -q 'require("atlas")' build/ArchHUD.inlined.lua; then
  echo "ERROR: inlined source still requires global atlas" >&2
  exit 1
fi
if grep -q 'mydu_atlas' build/ArchHUD.inlined.lua; then
  echo "ERROR: inlined source still references mydu_atlas require" >&2
  exit 1
fi

echo "Checking deploy-pack script exists..."
test -x scripts/deploy-pack.sh
test -x scripts/build-mydu.sh

echo "All static checks passed."
