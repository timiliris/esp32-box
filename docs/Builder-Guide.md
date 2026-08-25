# Builder guide

## Layout

- **Icon rail** (far left): four panels —
  **Cutouts** (the palette, shown on wall/lid tabs),
  **Floor layout** (PCB standoffs, cell holders, walls,
  compartments — shown on the Floor tab),
  **Objects** (everything in the project, click a row to jump to it,
  orange dot = warning),
  **Case** (inner dimensions, options, wall mounting, project reset).
  The panel follows the active tab automatically.
- **Selection inspector**, pinned at the bottom of the sidebar:
  numeric fields and actions for whatever is selected.
- **Face tabs**: Front / Back / Left / Right / Lid / Floor, each with
  an object counter. Walls are drawn as seen from outside; lid and
  floor are seen from above.
- **Footer**: generation buttons per part (Base, Lid, Inserts) and
  the equivalent OpenSCAD commands (folded by default — `‹›` shows
  them).

## Editing

| Action | How |
|---|---|
| Add an element | click it in the palette (lands centered, or at a sensible default height) |
| Move | drag — snaps to face center, mid-height, other elements' axes, 0.5 mm grid |
| Fine move | arrows = 1 mm, Shift+arrows = 0.1 mm |
| Exact values | type in the inspector fields |
| Duplicate / delete | inspector buttons, or Cmd/Ctrl+D / Del |
| Deselect | Escape, or click empty canvas |
| Undo / redo | Cmd/Ctrl+Z, Cmd/Ctrl+Shift+Z — a whole drag is one step |
| Zoom / pan | Ctrl+wheel (or pinch) / wheel — double-click resets |

Keep-out zones are shaded on the canvas: rounded corners at each end
of a wall, and the top band where the lid skirt and clips live.
Warnings list every conflict (top-left of the canvas) and are
clickable.

Compartments snap magnetically to the outer walls (6 mm sticky
zone) and get trimmed/joined into them; the plan shows fused sides
hatched and printed walls solid.

## Generation modes

The footer adapts to what's available:

1. **Local server detected** → “Generate STL” calls native OpenSCAD
   (fast, binary STL).
2. **No server, http(s) page** (the hosted version) → “Generate
   (browser)”: OpenSCAD WebAssembly in a worker, 1–3 min.
3. **Plain file://** → copy-paste OpenSCAD commands.

The **Inserts** card appears only when the project contains snap-in
windows or plunger buttons; print that plate in your second material
(clear/white PETG).

## 3D preview

Bottom-right, drag to rotate, chevron to collapse. The “open box”
button removes the lid and shows the interior layout (standoffs,
cell holders, walls, compartments) from above. Every cutout, vent
and window is drawn on the box at its real position — including the
lid and bottom faces.
