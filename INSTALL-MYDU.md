# MyDU ArchHUD install (North Industries)

ArchHUD fork with **bundled server planet data** (`mydu_atlas.lua`). You do **not** need to replace the global `Game/data/lua/atlas.lua` for this HUD.

Based on [Archaegeo-Orbital-Hud](https://github.com/Archaegeo/Archaegeo-Orbital-Hud) (GPL-3.0).

## Downloads

From [GitHub Releases](https://github.com/NorthIndustries/Archaegeo-Orbital-Hud/releases):

| Artifact | Use when |
|----------|----------|
| **MyDU-ArchHUD.zip** | Normal install (recommended) |
| **MyDU-ArchHUD.conf** | Modular conf only (you still need the `archhud/` folder from the zip) |
| **MyDU-ArchHUD-GFN.conf** | Atlas embedded in the conf; you still need the other `archhud/*.lua` modules on disk |

## Modular install (recommended)

1. Download **MyDU-ArchHUD.zip** from Releases.
2. Extract into your MyDU client folder:
   ```
   MyDU/Game/data/lua/autoconf/custom/
   ```
   You should have:
   - `MyDU-ArchHUD.conf`
   - `archhud/` (all module `.lua` files)
   - `archhud/custom/mydu_atlas.lua`
3. In game, on your pilot seat / control unit, apply autoconf profile **MyDU ArchHUD**.
4. Link elements per the usual ArchHUD manual (radar, databank, etc.).

Keep your vanilla `atlas.lua` unchanged; other HUDs may still depend on it.

## GFN-style install (atlas in conf)

1. Download **MyDU-ArchHUD-GFN.conf** → `MyDU/Game/data/lua/autoconf/custom/`
2. Copy the **`archhud/`** folder from **MyDU-ArchHUD.zip** to the same `autoconf/custom/` directory (all modules except atlas are still loaded via `require`).
3. Apply **MyDU ArchHUD GFN** in game.

**Note:** True GeForce Now single-file installs (no `archhud/` folder at all) require upstream **ArchHUDGFN.conf**-style full monolith builds. This GFN variant only inlines planet data, not the entire HUD codebase.

## Planet icons

`iconPath` values in `mydu_atlas.lua` point at client PNGs under `gui/screen_unit/img/planets/`. Custom bodies need those assets on the client, or reuse existing vanilla icon paths.

## Building from source

Requirements: `lua5.3` (or `lua`), `npm`, `zip`, `python3`.

```bash
cd scripts && npm install && cd ..
./scripts/build-mydu.sh false    # non-minified
# ./scripts/build-mydu.sh true   # minified (smaller conf)
```

Outputs:

- `MyDU-ArchHUD.conf` + `MyDU-ArchHUD.zip`
- `MyDU-ArchHUD-GFN.conf`

### Updating planet data

1. Update [`Game/data/lua/atlas.lua`](../../du-dl/ClientNew/MyDU/Game/data/lua/atlas.lua) on your admin client (canonical copy).
2. Copy into this repo:
   ```bash
   cp /path/to/MyDU/Game/data/lua/atlas.lua src/requires/custom/mydu_atlas.lua
   ```
   Preserve or refresh the header comment at the top of `mydu_atlas.lua`.
3. Bump `VERSION_NUMBER` in `src/ArchHUD.lua`.
4. Run `./scripts/build-mydu.sh` and publish a new release.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Wrong planet names / autopilot targets vanilla bodies | Old `archhud/custom/mydu_atlas.lua` missing or global `require("atlas")` conf — reinstall from **MyDU-ArchHUD.zip** |
| `no file '…lua' in the lua folder` | `archhud/` folder not copied to `autoconf/custom/` |
| HUD works but map icons wrong | Add missing planet PNGs or fix `iconPath` in atlas |

## Help

North Industries: [mydu.north-industries.com](https://mydu.north-industries.com)

Upstream ArchHUD docs: [Archaegeo user manual](https://docs.google.com/document/d/13-Kz1pqbbIHq8HTFLVG1r58D9zxsJe8_eTXezuryfPg/edit?usp=sharing)
