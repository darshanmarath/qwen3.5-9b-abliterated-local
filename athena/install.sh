#!/usr/bin/env bash
# Install Athena on this Mac: instructions, skills and Codex settings.
# Safe to run again. It backs up anything it replaces.
#
#   cd ~/Models && ./athena/install.sh
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/.." && pwd)"
CODEX_DIR="$HOME/.codex"
SKILLS_DIR="$HOME/.agents/skills"
CONFIG="$CODEX_DIR/config.toml"
STAMP="$(date +%Y%m%d-%H%M%S)"
MARK_START="# >>> athena >>>"
MARK_END="# <<< athena <<<"

say() { printf '%s\n' "$*"; }

say "Installing Athena from $REPO"
mkdir -p "$CODEX_DIR" "$SKILLS_DIR"

# 1. Instructions
if [ -f "$CODEX_DIR/AGENTS.md" ] && ! cmp -s "$HERE/AGENTS.md" "$CODEX_DIR/AGENTS.md"; then
  cp "$CODEX_DIR/AGENTS.md" "$CODEX_DIR/AGENTS.md.backup-$STAMP"
  say "  Backed up your existing AGENTS.md"
fi
cp "$HERE/AGENTS.md" "$CODEX_DIR/AGENTS.md"
say "  Instructions -> $CODEX_DIR/AGENTS.md"

# 2. Skills
for d in "$HERE"/skills/athena-*; do
  name="$(basename "$d")"
  rm -rf "${SKILLS_DIR:?}/$name"
  cp -R "$d" "$SKILLS_DIR/$name"
  say "  Skill        -> $SKILLS_DIR/$name"
done

# 3. Codex settings: replace any earlier Athena block, then add the current one
touch "$CONFIG"
if grep -qF "$MARK_START" "$CONFIG"; then
  cp "$CONFIG" "$CONFIG.backup-$STAMP"
  awk -v s="$MARK_START" -v e="$MARK_END" '
    index($0, s) {skip=1; next}
    index($0, e) {skip=0; next}
    !skip {print}
  ' "$CONFIG.backup-$STAMP" > "$CONFIG"
fi

{
  printf '\n%s\n' "$MARK_START"
  # The local model provider, unless you already defined one with this name
  if ! grep -q '^\[model_providers\.llamacpp\]' "$CONFIG"; then
    cat <<'TOML'
[model_providers.llamacpp]
name = "llama.cpp"
base_url = "http://127.0.0.1:8080/v1"
wire_api = "responses"

TOML
  fi
  grep -v '^#' "$HERE/codex-config.toml"
  printf '%s\n' "$MARK_END"
} >> "$CONFIG"
say "  Settings     -> $CONFIG"

# 4. Private folders, kept out of git
mkdir -p "$HERE/study/private/outbox" "$HERE/study/private/responses" \
         "$HERE/study/private/transcripts" "$HERE/voice/private"
if [ ! -f "$HERE/study/private/participants.csv" ]; then
  printf 'id,name,email,source,invited_on,consent,status,notes\n' > "$HERE/study/private/participants.csv"
fi
say "  Private data -> $HERE/study/private (never committed)"

# 5. What is still missing
say ""
missing=0
command -v llama-server >/dev/null 2>&1 || { say "MISSING  llama-server   brew install llama.cpp"; missing=1; }
command -v codex        >/dev/null 2>&1 || { say "MISSING  codex          npm install -g @openai/codex"; missing=1; }
[ "$missing" -eq 0 ] && say "llama-server and codex are both installed."

say ""
say "Next:"
say "  1. Start the model, in its own Terminal window:   $REPO/run.sh"
say "  2. Sign in to the tools, once each:"
say "       codex mcp login mobbin"
say "       codex mcp login figma"
say "       codex mcp login higgsfield"
say "  3. Start Athena from the repo folder:"
say "       cd $REPO && codex --profile athena"
