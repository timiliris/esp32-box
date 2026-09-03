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

The panel prints the **thread thickness** — `0.45 × lead / starts`,
the axial height of one thread. That is the number that matters on
FDM: below 1.2 mm a thread is barely three layers and strips. Three
starts on a 6 mm lead gives 0.9 mm, which is why the defaults moved to
a **10 mm lead**: same three starts, same 120° to open, but 1.5 mm of
thread. A coarse pitch beats a fine one here.

## Double wall

*Double wall* seals air between two shells, thermos style. By default
it is a ring of **vertical tubes** rather than one continuous gap: the
webs between them tie the two shells together, so the pot stays stiff,
and there is not a single bridge to cross — they are only holes. Set
*Number of tubes* to 0 for a plain continuous gap.

The insulation runs on the **sides only**. Under the floor it would ask the
printer to bridge the whole width of the pot in mid-air, which nothing
can do — and the sides are where most of the heat leaves anyway. At
the top the shoulder closes the gap: that ceiling is a bridge only as
wide as the gap itself, a few millimetres, which the nozzle crosses
without a thought. At the bottom, *Solid base* keeps a plinth under
the inner shell so it has something to stand on.

| | |
|---|---|
| Number of tubes | 28 by default; 0 gives a continuous gap |
| Tube diameter | 3 mm default; under 2 they close up when printed |
| Inner wall | the one the contents touch |
| Solid base | plinth kept under the gap |

It costs volume: a Ø 70 jar drops from 321 ml to 239. The panel
recomputes as you type, and the section draws both shells.

All three views show them: the section in dashed outline, the top view
tube by tube, and the 3D **through the wall** — they are internal, so
they are drawn in transparency rather than left out.

**The lid is insulated too**, and it has to be: closed, a plain 2.4 mm
top plate throws away most of what the walls just saved. Its ceiling
becomes two skins with a honeycomb of air pockets between them —
little wells, each capped by a bridge no wider than itself, so the lid
still prints face-down with nothing to support. Turn it off and the
panel says what it costs.

The panel prints the **web** left between neighbouring tubes and
refuses a count that would make them run into each other.

**A double-walled body reports more than two volumes, and that is
correct**: the solid, the outside, and every sealed air pocket counted
as its own enclosed void — 30 for 28 tubes, 3 for a continuous gap,
and 75 for an insulated lid with its honeycomb. Only a single-wall pot
should come out at two.

## Label holder

A flat is planed into the barrel and a frame sits on it. The tongue
**slides in from the top** — the slot is open up there, so nothing
overhangs, and the frame's window is a plain bridge between two
supported sides. No supports anywhere.

| | |
|---|---|
| Tongue | width, height, thickness — the slot takes it plus 0.5 |
| Frame | border width, and the front face thickness |
| Height on the barrel | where the frame's bottom sits |
| Flat | how deep the chord is planed |

Two things the flat has to respect. It is planed **deeper than the
flutes** — otherwise they cut straight across it and the frame no
longer sits flat — and it is planed **only over the frame's band**,
not the whole barrel, so the flutes survive above and below it. The
panel says so when the flat is too shallow.

The frame drives the flat, not the other way round: the default is a
tall strip running most of the barrel. Shorten *Tongue height* and the
planed area shrinks with it.

The **Tongue** part appears as a third button once the holder is on:
print it flat, write on it, slide it in. The panel refuses a flat
deeper than the material available — it would pierce the wall — and
warns when the frame runs past the top of the barrel or wraps too far
around the curve to sit flat.

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
