// Worker de génération : OpenSCAD compilé en WebAssembly.
// Reçoit { src, args } (source .scad + expressions -D), renvoie le STL
// binaire — tout tourne dans le navigateur du visiteur.
import OpenSCAD from "./openscad.js";

self.onmessage = async (e) => {
  const { src, args } = e.data;
  const logs = [];
  try {
    const inst = await OpenSCAD({
      noInitialRun: true,
      print: () => {},
      printErr: (t) => { logs.push(t); if (logs.length > 30) logs.shift(); },
    });
    inst.FS.writeFile("/box.scad", src);
    const argv = ["/box.scad", "-o", "/out.stl", "--export-format=binstl"];
    for (const a of args) argv.push("-D", a);
    try {
      inst.callMain(argv);
    } catch (err) {
      // Emscripten lève ExitStatus même en cas de succès (exit 0)
      if (!(err && err.name === "ExitStatus" && err.status === 0)) throw err;
    }
    const out = inst.FS.readFile("/out.stl");
    self.postMessage({ ok: true, stl: out.buffer }, [out.buffer]);
  } catch (err) {
    self.postMessage({
      ok: false,
      error: String(err && err.message || err) +
        (logs.length ? "\n" + logs.slice(-4).join("\n") : ""),
    });
  }
};
