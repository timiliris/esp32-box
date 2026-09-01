#!/usr/bin/env python3
"""Serveur local du ESP32 Box Builder.

Sert l'interface (http://127.0.0.1:8765) et génère les STL en appelant
l'OpenSCAD installé sur la machine. Aucune dépendance hors stdlib.

Usage : python3 builder-server.py   (ou double-clic sur builder.command)
"""
import http.server
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import webbrowser

PORT = 8765
ROOT = os.path.dirname(os.path.abspath(__file__))
# Modèles disponibles. La requête choisit par nom : jamais de chemin
# venu du client, sinon n'importe quel fichier deviendrait générable.
MODELES = {'box': 'esp32-box.scad', 'bottle': 'bottle.scad'}
SCAD = os.path.join(ROOT, MODELES['box'])
OPENSCAD = shutil.which('openscad') or '/opt/homebrew/bin/openscad'

# n'accepte que des définitions de variables OpenSCAD : nom=valeur,
# valeurs limitées aux nombres, chaînes, listes — pas de méta-caractères
ARG_RE = re.compile(r'^[A-Za-z0-9_]+=[A-Za-z0-9_"\[\],.\-]*$')


class Handler(http.server.BaseHTTPRequestHandler):
    def _cors(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')

    def _reply(self, code, body, ctype):
        self.send_response(code)
        self._cors()
        self.send_header('Content-Type', ctype)
        self.send_header('Content-Length', str(len(body)))
        # jamais de cache : l'interface évolue souvent
        self.send_header('Cache-Control', 'no-store')
        self.end_headers()
        self.wfile.write(body)

    def do_OPTIONS(self):
        self.send_response(204)
        self._cors()
        self.end_headers()

    STATIC = {
        '/esp32-box.scad': 'text/plain; charset=utf-8',
        '/wasm/openscad.js': 'text/javascript',
        '/wasm/openscad.wasm.js': 'text/javascript',
        '/wasm/openscad.wasm': 'application/wasm',
        '/wasm/worker.js': 'text/javascript',
    }

    def do_GET(self):
        path = self.path.split('?', 1)[0]
        if path in ('/', '/index.html', '/builder.html', '/bottle-builder.html'):
            nom = 'bottle-builder.html' if path == '/bottle-builder.html' \
                  else 'builder.html'
            with open(os.path.join(ROOT, nom), 'rb') as f:
                self._reply(200, f.read(), 'text/html; charset=utf-8')
        elif path == '/ping':
            body = json.dumps({'ok': True, 'openscad': OPENSCAD}).encode()
            self._reply(200, body, 'application/json')
        elif path in self.STATIC:
            with open(os.path.join(ROOT, path.lstrip('/')), 'rb') as f:
                self._reply(200, f.read(), self.STATIC[path])
        else:
            self._reply(404, b'{}', 'application/json')

    def do_POST(self):
        if self.path != '/generate':
            self._reply(404, b'{}', 'application/json')
            return
        out = None
        try:
            n = int(self.headers.get('Content-Length', 0))
            req = json.loads(self.rfile.read(n))
            part = req.get('part')
            args = req.get('args', [])
            modele = req.get('model', 'box')
            if modele not in MODELES:
                raise ValueError('modèle invalide')
            if part not in ('base', 'lid', 'inserts', 'stand', 'body', 'both'):
                raise ValueError('part invalide')
            if not isinstance(args, list) or not all(
                    isinstance(a, str) and ARG_RE.match(a) for a in args):
                raise ValueError('argument invalide')
            out = tempfile.NamedTemporaryFile(suffix='.stl', delete=False).name
            # binstl : STL binaire, ~5x plus léger et plus rapide à trancher
            cmd = [OPENSCAD, '-o', out, '--export-format', 'binstl']
            for a in args:
                cmd += ['-D', a]
            cmd.append(os.path.join(ROOT, MODELES[modele]))
            r = subprocess.run(cmd, capture_output=True, text=True,
                               timeout=300, cwd=ROOT)
            if r.returncode != 0 or not os.path.getsize(out):
                raise RuntimeError((r.stderr or 'échec OpenSCAD')[-2000:])
            with open(out, 'rb') as f:
                self._reply(200, f.read(), 'application/octet-stream')
        except Exception as e:
            body = json.dumps({'error': str(e)}).encode()
            self._reply(400, body, 'application/json')
        finally:
            if out and os.path.exists(out):
                os.unlink(out)

    def log_message(self, fmt, *a):
        sys.stderr.write('[builder] ' + fmt % a + '\n')


if __name__ == '__main__':
    if not os.path.exists(OPENSCAD):
        sys.exit('OpenSCAD introuvable — installe-le : brew install openscad')
    srv = None
    for port in range(PORT, PORT + 10):
        try:
            srv = http.server.ThreadingHTTPServer(('127.0.0.1', port), Handler)
            break
        except OSError:
            continue
    if srv is None:
        sys.exit(f'aucun port libre entre {PORT} et {PORT + 9}')
    print(f'ESP32 Box Builder : http://127.0.0.1:{port}   (Ctrl+C pour arrêter)')
    webbrowser.open(f'http://127.0.0.1:{port}')
    srv.serve_forever()
