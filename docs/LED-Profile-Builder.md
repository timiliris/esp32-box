# LED Profile Builder

Third generator in the repo, same look and same server: **clip-together
LED diffuser profiles** with a tilted channel. Open
`led-builder.html`, or drive `led-profile.scad` from the command line.

Two parts:

- **the segment** — plate, channel, visor, and the joint at both ends;
- **the diffuser** — a flat strip that slides into the grooves, to
  print in translucent PETG.

## The idea

A **plain channel with a flat sole**, glued on a border — a stair
stringer, a skirting, a shelf edge. The whole sole bears, so nothing
tips. What is tilted is the **strip**, not the profile: it lies on a
ramp inside the channel, aimed at the wall, and the taller jaw acts as
its visor.

| | |
|---|---|
| Tilt | 0° = strip flat, firing straight up; higher aims it at the wall |
| Visor | how far the tall jaw stands above the diffuser |
| Gap to diffuser | measured **perpendicular** to the strip |

**The diffuser is parallel to the strip**, not horizontal. Lay it flat
over a tilted strip and the gap runs from 3 mm at one edge to 12 at
the other: hot spots on one side, dull on the other. Parallel, the gap
is the same the whole way across — and the profile ends up shorter
too, 16.7 mm tall at 55° instead of 21.4.

The inner width is **derived**, not asked for: a strip laid at an angle
takes `strip_w × cos(angle)` across, so the channel is exactly that
wide plus the fitting play. Tilt more and the profile gets narrower and
taller — 10.9 × 16.8 mm at 45°, 9.5 × 16.7 at 55°. The diffuser is
sized off the ramp, so its width barely moves: 12.3 mm at 45°, 12.5 at
55°.

## Reading the section

The live section draws the beam in yellow between its two limiting
rays, from one edge of the strip over the opposite lip, and shades in
green the zone from which the LEDs cannot be seen.

Two numbers matter. **Overshoot towards the stairs** is the glare
figure: how far past vertical the beam — and the direct sight of the
strip — reaches on the side you walk. Smaller is better shielded; past
30° the panel says so. **Reach towards the wall** is how wide the wash
is on the other side.

At 55° with an 8 mm visor: 17.8° of overshoot for 60° of reach. At 65°
with 14 mm: 10.3° for 53°.

## Joining segments

The tenon is cut in the **sole**, the only part solid enough for it,
with a small ridge that clicks into the matching groove. Building it
as a shrunken copy of the whole section does not work: on thin jaws an
inward offset erases them and the tenon comes out as a loose sliver.

**The wire runs inside the channel**, alongside the strip, as it does
in an aluminium profile — there is room under the ramp on the low
side. Nothing to drill.

## Printing

The segment prints lying on its sole — the face that gets glued is the
one on the bed, so it comes out flat. The ramp is the only inclined
face and it faces up: no supports. Segment length is
yours to set — cut it to your bed and clip as many as the run needs.
