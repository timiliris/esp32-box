# OpenSCAD reference

Everything the builder does goes through `esp32-box.scad` and `-D`
definitions — you can script it without the UI.

```bash
openscad -o box-base.stl --export-format binstl \
  -D 'size_preset="custom"' -D 'custom_inner=[100,70,40]' \
  -D 'part="base"' esp32-box.scad
```

## Parts

`part` : `"base"`, `"lid"`, `"both"` (side by side), `"assembled"`
(closed view), `"inserts"` (snap-in windows + plunger caps, printed
flat).

Generate the **lid** with the same `compartments` / `dividers` /
lid `cuts` values as the base — it carries the matching cutouts and
skirt clearances.

## Main parameters

| Parameter | Default | Meaning |
|---|---|---|
| `size_preset` | `"M"` | S / M / L / XL / custom |
| `custom_inner` | `[100,70,40]` | inner W × D × H when custom |
| `wall`, `floor_t`, `lid_t` | 2.4 / 2.0 / 3.0 | shell thicknesses |
| `corner_r`, `edge_r` | 9 / 2.5 | corner radius, top fillet |
| `lid_fix` | `"snap"` | `"snap"` or `"screws"` |
| `lid_clearance` | 0.25 | lid fit |
| `snap_sides`, `notch_sides` | `"x"` | clips / opening notches: `x` sides, `y` front-back |
| `vents` | true | automatic side vent strip |
| `tie_slots` | true | zip-tie slots in the floor |
| `standoffs`, `hole_x`, `hole_y` | true, 44.5, 20.5 | legacy default board posts |
| `hole_comp` | 0.3 | FDM widening of functional holes |
| `teardrop` | true | teardrop round wall holes (≥ Ø 5) |
| `mount_tabs`, `mount_n`, `mount_hole` | `"none"`, 2, 4.2 | wall-mount eyelets (`"x"`/`"y"`) |

Legacy single-feature helpers also exist (`usb_cutout`,
`radar_window`, `led_window`, `cable_hole`, `side_usbc`,
`audio_hole`, `button_hole`) — see the comments in the .scad.

## List parameters (what the builder emits)

### `cuts` — anything on a face

`[face, type, off, z, a, b, skin]`

- `face`: `"front" | "back" | "left" | "right" | "lid" | "floor"`
- `off`, `z`: position — walls: offset along the wall (global axis)
  and height above the inner floor; lid/floor: X and Y from center
- types: `"rect"` (a×b), `"circle"` (Ø a), `"window"` (blind, keeps
  `skin` mm outside), `"insert"` (rabbeted hole + separate snap-in
  window, membrane = `skin`, 0 = open frame), vents
  `"vslots" | "hslots" | "grid" | "hex"` (a×b zone), buttons
  `"btnflex" | "btnpiston"` (walls only, a = cap Ø), `"usbc"`
  (flush USB-C mount, a×b opening)

### `standoff_sets` — PCB posts on the floor

`[cx, cy, dx, dy, h, d, pilot, two]` — spacing dx×dy, post height/Ø,
pilot Ø; `two=1` → only 2 posts at linked signs (pair if dy=0,
diagonal otherwise).

### `cell_holders` — battery cradles

`[cx, cy, rot, length, dia]` — rot 0 = along X, 90 = along Y.

### `dividers` — internal walls

`[cx, cy, rot, length, height, thickness, pass_w, pass_off, vented]`
— height 0 = full (to the lid); `pass_w` top cable notch (0 = none);
`vented=1` adds top+bottom crenels. Overlap outer walls freely: the
result is trimmed to the inner volume.

### `compartments` — sensor isolation frames

`[cx, cy, w, d, vent_floor, vent_lid, pass_side, pass_w, vent_walls]`
— full-height frame around a w×d zone, trimmed into the outer walls
when overlapping. `vent_floor/lid/walls = 1` cut honeycomb below /
above / in the touching outer walls. `pass_side`: −1 none, 0 front,
1 back, 2 left, 3 right.

## Local server API

`builder-server.py` (Python stdlib) serves the UI on
http://127.0.0.1:8765 (falls back up to :8774) and exposes:

- `GET /ping` → `{"ok": true, "openscad": "<path>"}`
- `POST /generate` `{"part": "base|lid|inserts", "args": ["-D
  expressions…"]}` → binary STL. Args are validated against a strict
  `name=value` pattern; OpenSCAD runs without a shell.
