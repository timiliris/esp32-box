#!/bin/bash
# Double-clic : lance le serveur du ESP32 Box Builder et ouvre l'interface
cd "$(dirname "$0")"
exec python3 builder-server.py
