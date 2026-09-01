# LED Profile Builder

Third generator in the repo, same look and same server: **clip-together
LED diffuser profiles** with a tilted channel. Open
`led-builder.html`, or drive `led-profile.scad` from the command line.

Two parts:

- **the segment** — plate, channel, visor, and the joint at both ends;
- **the diffuser** — a flat strip that slides into the grooves, to
  print in translucent PETG.

## The idea

The profile screws to a support — a wall, the underside of a stair
nosing, a ceiling. The channel that carries the strip is **tilted**
relative to that support, and that tilt is what sends the light where
you want it. A **visor** extends the jaw on the eye side so the LEDs
are never seen head-on.

| | |
|---|---|
| Tilt | 0° = straight out, 90° = grazing along the support |
| Depth | how far the strip is recessed |
| Visor | extra length on the shielded jaw |

## Reading the section

The live section draws the beam in yellow between its two limiting
rays — from one edge of the strip over the opposite lip. Both angles
are given **relative to the support**, not to its normal, because that
is how you think about a wall-grazer: 0° hugs the wall, 90° fires
straight out.

Beyond the visor's ray the light stops, so the LEDs cannot be seen
from there: that zone is shaded green. For a staircase, the number to
watch is the **visor-side edge** — the smaller it is, the further you
have to lean out before the strip glares at you.

The *Stair wall-grazer* preset lands at 36° on the visor side and −28°
on the wall side: a beam straddling the wall, invisible from the
steps.

## Joining segments

The tenon is cut in the **plate**, the only part thick enough for it,
with a small ridge that clicks into the matching groove. Building it
as a shrunken copy of the whole section does not work: on 2 mm jaws an
inward offset erases them and the tenon comes out as a loose sliver.

**The wire runs inside the channel**, alongside the strip, as it does
in an aluminium profile. A dedicated through-hole was tried and
removed: it cut straight through the junction between the channel and
the plate and left the two detached.

## Printing

The segment prints lying on its mounting plate. Segment length is
yours to set — cut it to your bed and clip as many as the run needs.
