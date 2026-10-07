#!/usr/bin/env bash
# Start llama-server for one of the two local builds.
#   ./run.sh        -> Q4_K_M (default)
#   ./run.sh f16    -> F16
set -euo pipefail

MODELS_DIR="${MODELS_DIR:-$HOME/Models}"

case "${1:-q4}" in
  q4|Q4|q4_k_m) FILE="Qwen3.5-9B-abliterated-Q4_K_M.gguf" ;;
  f16|F16)      FILE="Qwen3.5-9B-abliterated-F16.gguf" ;;
  *) echo "usage: $0 [q4|f16]" >&2; exit 1 ;;
esac

exec llama-server \
  -m "$MODELS_DIR/$FILE" \
  --alias qwen3.5-9b \
  --ctx-size "${CTX_SIZE:-32768}" \
  --parallel 1 \
  --port "${PORT:-8080}" \
  --jinja \
  -ngl 99
