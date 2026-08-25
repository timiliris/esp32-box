# Getting started

## Two ways to run it

**Online (nothing to install)** —
https://timiliris.github.io/esp32-box/builder.html
STL generation runs in your browser through OpenSCAD compiled to
WebAssembly. Expect 1–3 minutes per part; the first generation also
downloads the ~8 MB engine. Your project auto-saves in the browser.

**Locally (fast)** — with [OpenSCAD](https://openscad.org) and
Python 3 installed:

```bash
git clone https://github.com/timiliris/esp32-box.git
cd esp32-box
python3 builder-server.py
```

The interface opens at http://127.0.0.1:8765 and the “Generate STL”
buttons call your native OpenSCAD (15–60 s per part). On macOS,
double-clicking `builder.command` does the same thing.

The interface is bilingual — it follows your browser language, and
the EN/FR chip in the header switches at any time.

## Your first box, in five minutes

1. **Pick a size** — click a preset chip (S/M/L/XL) in the header,
   or open the **Case** panel (cube icon) and type inner dimensions.
2. **Place your board** — go to the **Floor** tab; the left panel
   switches to floor tools. Under *PCB standoffs*, pick your board
   (e.g. “30-pin ESP32 DevKit”) or type a measured hole spacing,
   click *Add group*, then drag the group where you want it. It
   snaps to the center and to other objects.
3. **Add connectors** — switch to a wall tab (Front, Back, sides),
   pick from the palette (USB-C, jack, buttons…). Drag to position:
   dashed zones mark the areas to avoid (rounded corners, lid skirt).
   Orange warnings appear top-left if something won't fit — click a
   warning to jump to the offending element.
4. **Check in 3D** — the preview bottom-right rotates with the
   mouse; the “open box” button shows the interior layout.
5. **Generate** — bottom bar: *Base* and *Lid* (and *Inserts* if
   you used snap-in windows or plunger buttons). Each button
   downloads a binary STL ready to slice.

## Printing in one line

0.2 mm layers, 2–3 perimeters, 15 % infill, PLA or PETG, **no
supports needed**. See [Printing & assembly](Printing-and-Assembly.md).
