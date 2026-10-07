#!/usr/bin/env bash
# Speak text in the designer's own voice, on this Mac, with F5-TTS (MLX).
# Nothing is uploaded. Apple Silicon only.
#
#   ./speak.sh --prep private/ref.m4a      convert a recording into the reference clip
#   ./speak.sh "Three invites are ready."  speak a line
#   ./speak.sh -o out.wav "Some text."     save to a file instead of playing
#
# One-time setup:
#   brew install ffmpeg
#   python3 -m venv ~/.venvs/athena-voice
#   ~/.venvs/athena-voice/bin/pip install f5-tts-mlx
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
PRIV="$HERE/private"
REF_WAV="$PRIV/ref.wav"
REF_TXT="$PRIV/ref.txt"
PY="${ATHENA_VOICE_PY:-$HOME/.venvs/athena-voice/bin/python}"

# The words spoken in the reference clip. Must match the recording exactly.
DEFAULT_REF_TEXT="Hi, I'm Darshan. I design products where people and AI have to understand each other, and I like to keep things clear, calm and honest."

if [ "${1:-}" = "--prep" ]; then
  [ $# -eq 2 ] || { echo "usage: $0 --prep <recording>" >&2; exit 1; }
  mkdir -p "$PRIV"
  # F5-TTS wants mono, 24 kHz WAV, about 5 to 10 seconds.
  ffmpeg -loglevel error -y -i "$2" -ac 1 -ar 24000 -sample_fmt s16 -t 10 "$REF_WAV"
  [ -f "$REF_TXT" ] || printf '%s\n' "$DEFAULT_REF_TEXT" > "$REF_TXT"
  echo "Reference clip: $REF_WAV"
  echo "Reference text: $REF_TXT  (edit it if you said something different)"
  exit 0
fi

OUT=""
if [ "${1:-}" = "-o" ]; then
  OUT="$2"; shift 2
fi

[ $# -ge 1 ]      || { echo "usage: $0 [-o file.wav] \"text to speak\"" >&2; exit 1; }
[ -x "$PY" ]      || { echo "Voice environment missing. See setup at the top of this file." >&2; exit 1; }
[ -f "$REF_WAV" ] || { echo "No reference clip. Run: $0 --prep <recording>" >&2; exit 1; }

ARGS=(--text "$*" --ref-audio "$REF_WAV" --ref-text "$(cat "$REF_TXT")")
[ -n "$OUT" ] && ARGS+=(--output "$OUT")

exec "$PY" -m f5_tts_mlx.generate "${ARGS[@]}"
