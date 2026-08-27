# Elements reference

All dimensions are the **nominal connector sizes** — the FDM
compensation (default +0.3 mm) is applied at generation time.

## Connectors (walls)

| Element | Opening | Notes |
|---|---|---|
| Flush USB-C | 8.7 × 2.9 | For a **bare** female USB-C receptacle (solder shell). Built-in channel mount behind the wall; nose flush outside. Geometric lock: plugging pushes against the back stop, unplugging presses the shell against the wall. Insert from the top, wires out the back. Shell length is adjustable in the inspector (default 12.6 mm — measure yours: 7.35 / 10.5 / 12.6 mm variants exist). |
| USB-C | 10 × 6 | Pass-through for a whole cable connector, when the receptacle sits recessed on a board. |
| USB-A | 14 × 8 | Same, USB-A. |
| micro-USB | 9 × 5 | Same, micro-USB. |
| Port row | 64 × 10 | Wide opening for a power-bank module's port row. |
| Power bank ports | 62 × 9 | Port-row opening matched to a 65.5 × 27 × 7.5 power bank charger module. Default height assumes the module sits on 5 mm standoffs — pair it with the matching standoff preset. |
| Jack 3.5 | Ø 6.5 | Panel-mount jack, screws with its own nut. |
| Push btn 7 / 12 | Ø 7.2 / 12.2 | Panel-mount push buttons (PBS-110 style / 12 mm metal). |
| PG7 | Ø 12.5 | Cable gland for a clean strain-relieved cable exit. |
| Rocker KCD1 | 19.2 × 13.2 | The standard small rocker switch. |
| LED pipe 1.75 | Ø 1.8 | Push a short piece of **clear filament** in as a light pipe for a status LED. Friction fit. |

## 6×6 tact switch buttons (walls)

Both use the same **built-in cradle**: a chamfered block behind the
wall with an open-top pocket for a standard 6×6 tact switch. Solder
two wires, slide the switch in — alignment is guaranteed.

- **Flex button** — printed in place: a U-slot cuts a flexible
  tongue in the wall (thinned hinge at the top), with a flush cap
  outside and a presser boss inside. Zero assembly.
- **Plunger button** — a sliding piston: cap prints on the Inserts
  plate, inserted from the inside, retained by its flange; the
  switch's own spring returns it. A real protruding clicky button.

Keep them away from corners (the cradle needs ~13 mm of wall on each
side for the flex version) — the builder warns if too close.

## Displays

**7″ 1024×600 display window** (lid) — sized for the Waveshare
ESP32-P4-WIFI6-Touch-LCD-7B and equivalent panels. Measured from the
official drawings:

| | mm |
|---|---|
| PCB outline | 164.00 × 97.00 |
| Mounting holes (spacing) | **156.00 × 89.00**, centered on the PCB |
| Cover glass | 164.28 × 99.17 |
| **Active area** | **154.58 × 86.42** |
| Bezels | left 3.06 · right 6.65 · top 4.02 · bottom 8.73 |

The panel is **not centered**: its active area sits 1.79 mm left of
and 2.36 mm above the board center. The palette window is placed with
that offset already applied (viewed from outside the lid, USB side on
the left) and is 1.5 mm smaller per edge so the bezel overlaps the
panel border.

**How it is held.** The cover glass (164.28 × 99.17) covers the whole
PCB, so the 4 mounting holes are **not reachable from the front** —
you cannot screw through the screen, and a boss coming down from the
lid would crush the glass. The module **clips into the lid** instead:
**retaining clips** (Floor layout panel → *Add retaining clips*) rise
from the lid's inner face, pass around the glass on the outside and
hook over the **back of the PCB**. The lid frame holds the module
from the front, the clips from behind — no screws at all.

Two depths matter, both measured from the glass resting under the lid
(values below measured on the real module):

| | mm |
|---|---|
| Screen assembly (glass + panel + PCB) | **8.6** — the edge connectors sit at this level |
| Tallest point of the board (top of its own standoffs) | **14.5** — where our printed posts land |

So the board carries ~6 mm standoffs of its own — which is why the
inner height is 45 mm: the module takes 14.5 from the lid, leaving
about 30 mm for the down-facing plugs and their cables.

The clips catch at the **screen thickness** (8.6): set *Catch depth*
to your module's glass-to-PCB-back distance, *Module width/depth* to
its outline, and *Lip* to how far the hook overlaps the board (2 mm
by default). Two clips per side is plenty for a 7″ panel.

**Leave one side open.** A glass panel cannot be forced between eight
rigid clips, so *Insertion side* removes the clips from one edge: you
slide the module in underneath the others from that side, and the
remaining clips hold it. The plan marks the open edge with an arrow.

**Clips avoid the connectors.** Positions are not evenly spaced: the
builder looks at the wall cutouts on each edge (USB, buttons, card
slot…) and drops each clip into the nearest free gap, so a clip never
lands in front of a port. Narrow the *Clip width* (10 mm on the 7B
template instead of 14) to fit more of them on a crowded edge; if one
still has nowhere to go, a note says so and the others are placed
anyway.

Board edge features, measured from the drawing (distance from the
top edge, back view — mirror the X when seen from the front):

| Feature | Edge | Position |
|---|---|---|
| ON/OFF slide switch | right | 12.1 from top |
| USB-A (OTG) | right | center 49.4 from top |
| USB-C (USB) | right | center 68.2 from top |
| USB-C (to UART) | right | center 83.4 from top |
| RESET / BOOT buttons | left | centers **10 and 19** from the top edge — measured on the real board |
| Camera | top (opposite the card reader) | **perfectly centred**: 78 mm from each side, 8 mm wide |
| microSD (TF) slot | bottom | slot spans **78 → 91** from the button edge (78 + 13 + 73 = 164), so 2.5 mm off the board centre — measured on the real board |

Minimum box for this display: about **176 × 109** inner, so the
window clears the rounded corners. The module itself is 10–15 mm
thick but its bottom-facing plugs need room: allow **40 mm** of
inner height.

**One-click template** — the *Case* panel has a **Templates**
section: “Waveshare ESP32-P4 7B — 7″ display” builds the whole
project (176 × 109 × 40 box, offset screen window, standoffs under
the lid, and all seven edge openings at the right height). Wall
openings created this way are **tied to the lid**: change the box
height and they follow the board instead of staying at a fixed
height above the floor. Any wall cutout can be tied that way with
the “Height tied to the lid” checkbox.

## Side openings and the lid skirt

Wall cutouts near the top of the box (typical when a board hangs
under the lid) also **notch the lid skirt**, so connectors, card
slots and buttons pass all the way through. The builder shows a blue
note — “N cutouts cross the skirt — regenerate the lid” — which is
not a problem: the openings do go through, it is only a reminder
that the **lid must be regenerated** along with the base.

## Windows & inserts (any face)

- **LED window** (74 × 12), **Radar window** (35 × 14 — the length
  of an LD2410B), **Custom insert**: create a **rabbeted**
  through-hole; the matching **snap-in window** prints on the
  Inserts plate — flush plate outside, two snap ridges inside. The
  center is a thin membrane (“Skin”, 0.8 mm default): LEDs glow
  through, mmWave sees through. **Skin 0 = open frame** (no
  membrane) for ToF lasers or any sensor needing open air.
- **Custom window** — single-material alternative: the wall itself
  thinned to “skin” thickness from the inside (no separate part).

## Vents (any face)

Zone-filling patterns — draw a rectangle, the pattern fills it and
recomputes so no cell is ever cut in half:
vertical slots (2 mm, 4.5 pitch), horizontal slots, staggered Ø 3
round grid, 5 mm honeycomb (the best-printing one on vertical
walls). There is also an automatic side-vent strip option in the
Case panel.

## Floor tools

- **PCB standoffs** — groups of 4 (rectangle) or 2 (pair /
  diagonal) posts with self-tapping pilot holes. “Mount under the
  lid” hangs the posts from the lid's inner face instead of the
  floor — for boards whose mounting holes stay reachable. “Locating
  pin Ø” replaces the screw pilot with a pin that drops into the
  board's hole, for a board that is pressed rather than screwed. Presets: dev
  boards, proto-board kits 2×8 → 9×15 cm (spacing = dimension − 4),
  common modules (GY-BME280 2-hole·10 verified, SSD1306 0.96″,
  GY-521, LM2596…, power bank charger module 65.5 × 27 →
  58.5 × 19.5, measured). Small modules get thin Ø 4.5 posts with M2
  pilots. Measure clone boards with calipers — ≈ values vary.
- **Cell holders** — printed cradles for 18650 / 21700 / 14500:
  two snap jaws (0.5 mm lip each side) + end stops. Rotate 90°,
  duplicate for packs.
- **Walls** — full-height (touches the lid) or partial, optional
  top cable notch, optional **vent crenels** top + bottom. Overlap
  them into the outer walls: they're trimmed and joined.
- **Compartments** — a closed frame to isolate a sensor, snapping
  magnetically against outer walls (fused sides shown hatched).
  Options: honeycomb vent **in the floor below**, **in the lid
  above** (chimney airflow — regenerate the lid!), and **in the
  touching outer walls**. Cable pass on any of the four frame walls
  (not on a fused one — the builder warns).

## Case panel

Inner dimensions, side-vent strip, zip-tie slots, lid fixing
(snap-fit / screwed), FDM hole clearance, teardrop holes, and
**wall-mounting tabs**: 2 or 4 Ø 4.2 eyelets at floor level, on the
sides or front/back, printed with the base.
