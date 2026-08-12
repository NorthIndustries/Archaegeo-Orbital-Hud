#!/bin/bash
# Static checks without requiring lua (CI runs full build-mydu.sh).
set -e

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "$ROOT"

echo "Checking atlas module..."
test -f src/requires/custom/mydu_atlas.lua
rg -q 'return \{' src/requires/custom/mydu_atlas.lua

echo "Checking ArchHUD.lua uses bundled atlas..."
rg 'require\("autoconf/custom/archhud/custom/mydu_atlas"\)' src/ArchHUD.lua
! rg 'require\("atlas"\)' src/ArchHUD.lua

echo "Checking inline-atlas..."
./scripts/inline-atlas.sh
rg -q 'local atlas = \{' build/ArchHUD.inlined.lua
! rg 'require\("atlas"\)' build/ArchHUD.inlined.lua
! rg 'mydu_atlas' build/ArchHUD.inlined.lua

echo "Checking deploy-pack script exists..."
test -x scripts/deploy-pack.sh
test -x scripts/build-mydu.sh

echo "All static checks passed."
