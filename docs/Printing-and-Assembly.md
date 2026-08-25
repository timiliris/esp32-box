# Printing & assembly

## Slicer settings

- **No supports.** Every part is designed for it: the lid is modeled
  outer-face down, cradles have 45° chamfered undersides, round wall
  holes are teardrops.
- 0.2 mm layers, 2–3 perimeters, 15 % infill.
- **PLA or PETG.** Prefer PETG when the box runs warm (PSU, relays)
  and for slightly softer snap clips. Print inserts in **clear
  PETG** (light pipes, radar windows) or white (diffusers).
- If your slicer complains about *relative E without reset*, add
  `G92 E0` to its before-layer-change G-code.

## FDM compensation (already built in)

- `hole_comp` (0.3 mm default, “Hole clearance” in the builder)
  widens every functional hole/cutout — enter nominal connector
  sizes, they come out right. If holes still print tight on your
  machine, raise it to 0.4.
- Round wall holes ≥ Ø 5 print as **teardrops** (45° roof) — no
  sagging. Below Ø 5 they stay round (small holes print fine).
- Pilot holes for screws are **not** compensated on purpose:
  self-tapping screws need bite.

## Assembly

**Lid** — align, press: the skirt ridges click into the wall
grooves. Open by pushing the lid edge up through a side notch. Too
tight/loose → `lid_clearance` (0.25 default), or print the lid in
PETG.

**Snap-in windows** — push into the rabbet from outside until
flush; the two ridges click behind the wall. Remove from inside by
pushing the body. If a clip is stiff, shave the ridge lightly.

**Flex button** — solder two wires on a 6×6 tact switch, drop the
switch into the cradle from the top, done. The printed tongue should
click the switch with a ~1 mm press.

**Plunger button** — from the Inserts plate. Insert the plunger
from **inside** the box (flange stays inside), then drop the switch
into its cradle. The switch spring returns the plunger.

**Flush USB-C** — for bare solder-shell receptacles (~9 × 3.2 mm
face). Solder wires first, slide the nose into the wall opening from
inside at a slight angle, lay the body down into the channel under
the rear bridge, wires out the back. Plug-in force goes to the back
stop, pull-out force to the wall: nothing stresses the solder
joints. Check your shell is ~7.5 mm long (some variants are 10.5+).

**Cell holders** — press the cell down into the jaws; end stops
block sliding. The 0.5 mm lips hold it; a strip of tape adds
security for portable boxes.

**Wall mounting** — screw through the Ø 4.2 eyelets into anchors;
4-tab mode for larger boxes.

## Sensor compartments

For a temperature/humidity sensor (BME280…): use a compartment with
floor + lid vents (chimney airflow) and optionally vented touching
walls. The sensor reads room air while isolated from the
electronics' heat. Route wires through the cable pass on a non-fused
wall. **Regenerate the lid** whenever the lid vent is enabled — the
lid carries the compartment cutouts and the skirt clearances.
