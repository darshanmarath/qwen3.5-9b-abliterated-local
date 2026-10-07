#!/usr/bin/env bash
# Transcribe an interview recording on this Mac with whisper.cpp.
# Nothing is uploaded.
#
#   ./transcribe.sh path/to/recording.m4a P03
#
# Writes athena/study/private/transcripts/P03.txt
#
# One-time setup:
#   brew install whisper-cpp ffmpeg
#   mkdir -p ~/Models/whisper
#   curl -L -o ~/Models/whisper/ggml-large-v3-turbo.bin \
#     https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "usage: $0 <recording> <participant-id>" >&2
  exit 1
fi

IN="$1"
ID="$2"
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT_DIR="$HERE/../study/private/transcripts"
MODEL="${WHISPER_MODEL:-$HOME/Models/whisper/ggml-large-v3-turbo.bin}"

# Homebrew has shipped the program under two names.
if command -v whisper-cli >/dev/null 2>&1; then
  WHISPER=whisper-cli
elif command -v whisper-cpp >/dev/null 2>&1; then
  WHISPER=whisper-cpp
else
  echo "whisper.cpp is not installed. Run: brew install whisper-cpp" >&2
  exit 1
fi

[ -f "$IN" ]    || { echo "No such recording: $IN" >&2; exit 1; }
[ -f "$MODEL" ] || { echo "No model at $MODEL. See setup at the top of this file." >&2; exit 1; }

mkdir -p "$OUT_DIR"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# whisper.cpp wants 16 kHz mono WAV.
ffmpeg -loglevel error -y -i "$IN" -ar 16000 -ac 1 -c:a pcm_s16le "$TMP/audio.wav"

"$WHISPER" -m "$MODEL" -f "$TMP/audio.wav" -l "${WHISPER_LANG:-auto}" \
  --output-txt --output-file "$OUT_DIR/$ID"

echo "Wrote $OUT_DIR/$ID.txt"
