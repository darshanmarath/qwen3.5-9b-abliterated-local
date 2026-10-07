#!/bin/bash
# Double-click to start Athena on this Mac.
# Starts the local model, Athena's space, and your portfolio preview,
# then opens both in your browser. Close this window to stop everything.

export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/local/node/bin:$PATH"
MODELS="$(cd "$(dirname "$0")" && pwd)"
PORTFOLIO="$HOME/career dev/portfolio"
LOGS="$MODELS/athena/space/private/logs"
mkdir -p "$LOGS"
PIDS=()

listening() { nc -z 127.0.0.1 "$1" >/dev/null 2>&1; }
stop_all() {
  echo ""; echo "Stopping Athena..."
  for p in "${PIDS[@]}"; do kill "$p" 2>/dev/null; done
  exit 0
}
trap stop_all INT TERM HUP

clear
echo "Starting Athena"
echo "==============="

# 1. The model
if listening 8080; then
  echo "[1/3] Model: already running on port 8080."
elif ! command -v llama-server >/dev/null 2>&1; then
  echo "[1/3] Model: llama-server is not installed."
  echo "      Install it with:  brew install llama.cpp"
  echo "      Then double-click this file again."
  read -r -p "Press Return to close." _; exit 1
else
  echo "[1/3] Model: loading Qwen3.5 9B (this can take a minute)..."
  "$MODELS/run.sh" > "$LOGS/model.log" 2>&1 &
  PIDS+=($!)
  for i in $(seq 1 180); do
    if curl -s -m 2 http://127.0.0.1:8080/health 2>/dev/null | grep -q '"ok"'; then break; fi
    if ! kill -0 "${PIDS[0]}" 2>/dev/null; then
      echo "      The model stopped while loading. Last lines of its log:"
      tail -n 12 "$LOGS/model.log" | sed 's/^/      /'
      read -r -p "Press Return to close." _; exit 1
    fi
    sleep 1
  done
  if curl -s -m 2 http://127.0.0.1:8080/health 2>/dev/null | grep -q '"ok"'; then
    echo "      Ready."
  else
    echo "      Still loading after 3 minutes. Carrying on; give it more time."
  fi
fi

# 2. Athena's space
if listening 8090; then
  echo "[2/3] Space: already running on port 8090."
else
  python3 -m http.server 8090 --bind 127.0.0.1 --directory "$MODELS/athena/space" > "$LOGS/space.log" 2>&1 &
  PIDS+=($!)
  echo "[2/3] Space: http://localhost:8090"
fi

# 3. Portfolio preview
if listening 3210; then
  echo "[3/3] Portfolio: already running on port 3210."
elif [ ! -d "$PORTFOLIO" ]; then
  echo "[3/3] Portfolio: folder not found, skipped."
elif ! command -v npm >/dev/null 2>&1; then
  echo "[3/3] Portfolio: npm not found, skipped."
else
  ( cd "$PORTFOLIO" && npm run dev -- -p 3210 > "$LOGS/portfolio.log" 2>&1 ) &
  PIDS+=($!)
  echo "[3/3] Portfolio: starting..."
  for i in $(seq 1 60); do listening 3210 && break; sleep 1; done
  listening 3210 && echo "      http://localhost:3210/work/athena" || echo "      Not up yet. See $LOGS/portfolio.log"
fi

sleep 1
open "http://localhost:8090/"
listening 3210 && open "http://localhost:3210/work/athena"

echo ""
echo "Athena is up."
echo "  Talk to the council:   http://localhost:8090"
echo "  Portfolio case study:  http://localhost:3210/work/athena"
echo ""
echo "Leave this window open. Close it, or press Ctrl+C, to stop everything."
wait
