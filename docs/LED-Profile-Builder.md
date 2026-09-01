# LED Profile Builder

Third generator in the repo, same look and same server: **clip-together
LED diffuser profiles** with a tilted channel. Open
`led-builder.html`, or drive `led-profile.scad` from the command line.

Two parts:

- **the segment** — plate, channel, visor, and the joint at both ends;
- **the diffuser** — a flat strip that slides into the grooves, to
  print in translucent PETG.

## The idea

The profile is **glued flat** on a border — a stair stringer, a skirting,
a shelf edge. No bracket, no screws: a wide sole gives the tape
something to hold. The channel that carries the strip is **tilted** on
that sole, and the tilt is what sends the light where you want it. A
**visor** extends the jaw on the eye side so the LEDs are never seen
head-on.

| | |
|---|---|
| Tilt | 0° = straight up, 90° = grazing the border. Positive leans toward the wall |
| Depth | how far the strip is recessed |
| Visor | extra length on the shielded jaw |
| Sole | width and thickness of the glued foot |

Screw holes remain available — set *Screws per segment* above 0 — but
they default to none.

## Reading the section

The live section draws the beam in yellow between its two limiting
rays — from one edge of the strip over the opposite lip. Both angles
are given **from the vertical**: 0° fires straight up, 90° grazes the
border. In the drawing the wall is on the left.

Beyond the visor's ray the light stops, so the LEDs cannot be seen
from there: that zone is shaded green. For a staircase, the number to
watch is the **visor-side edge** — the smaller it is, the further you
have to lean out before the strip glares at you.

What matters on a staircase is the **visor's cut-off**: the larger it
is, the further you have to lean over the steps before the strip
glares at you. Under 35° the panel says so.

## Joining segments

The tenon is cut in the **sole**, the only part thick enough for it,
with a small ridge that clicks into the matching groove. Building it
as a shrunken copy of the whole section does not work: on 2 mm jaws an
inward offset erases them and the tenon comes out as a loose sliver.

**The wire runs inside the channel**, alongside the strip, as it does
in an aluminium profile. A dedicated through-hole was tried and
removed: it cut straight through the junction between the channel and
the plate and left the two detached.

## Printing

The segment prints lying on its sole — the face that gets glued is the
one on the bed, so it comes out flat. Segment length is
yours to set — cut it to your bed and clip as many as the run needs.
