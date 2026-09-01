# Bottle Builder

A second generator in the same repo, same look, same server: parametric
**screw-top jars and bottles**. Open `bottle-builder.html` (the box
builder links to it in the header), or drive `bottle.scad` from the
command line.

## What comes out

Two parts, printed as they stand — no supports:

- **the pot** — base on the plate, mouth up;
- **the lid** — top on the plate, skirt up.

## The thread

The thread is swept as a real helix. `linear_extrude(twist=…)` drags a
2D profile along a helical path; making that profile **wide at the root
and narrow at the crest** turns the resulting (r, z) section into the
trapezoid a screw thread needs. A square thread would print as well but
grip worse and strip sooner.

| | |
|---|---|
| Lead | axial travel per turn |
| Depth | how far the thread stands out |
| Starts | 3 starts open in 1/3 of a turn; 1 start needs a full one |
| Clearance | play per flank, 0.35 is a good FDM starting point |

The panel prints the number of **turns of thread** and the angle needed
to open. Under one full turn it says so: the lid will feel loose.

## The body

**Flutes** are cut by a twisted circular tool rather than by twisting a
fluted profile. That matters: a fluted profile is concave, and twisting
a concave profile makes neighbouring slices self-intersect — the mesh
comes out open. A circle stays convex whatever the twist.

They do not run the whole height. *Plain band* at the bottom and at the
top leaves the flutes as an inset panel in the middle, which is what a
moulded jar looks like — and it keeps the ends of the pot stiff.

*Tool width* is the radius of the cutter: larger means a wider, gentler
groove for the same depth.

**Wall** is measured at the thinnest point, the bottom of a flute — not
at the ridges. Ask for 2 mm and you get 2 mm where it counts.

## Three views, live

- **Overview** — a computed isometric: the twist, the thread helix and
  the knurling, with the lid lifted off. No dependency, no wait.
- **Section** — the wall, the floor, the shoulder, the thread teeth,
  and the lid drawn screwed on.
- **From above** — the flutes and the bore.

Capacity, total height, lid diameter, turns of thread and opening angle
are recomputed on every keystroke, from the same formulas the `.scad`
uses.

## Presets

Fluted jar · slim bottle · wide smooth pot · pill box. Each is a
starting point, not a lock — every field stays editable.
