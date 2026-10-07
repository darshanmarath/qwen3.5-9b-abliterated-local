#!/usr/bin/env bash
# Open Athena's space on this Mac at http://localhost:8090
# The model must be running too:  ~/Models/run.sh
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PORT="${PORT:-8090}"
[ -f "$HERE/private/ambient.mp4" ] || echo "No video at $HERE/private/ambient.mp4. The space will use a plain background."
( sleep 1; open "http://localhost:$PORT/" 2>/dev/null || true ) &
echo "Athena's space is at http://localhost:$PORT/   (Ctrl+C to stop)"
exec python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$HERE"
