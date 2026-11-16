#!/bin/sh
# Installs the themes into the Claude Desktop Themes mod's own folder (~/.claude/themes-for-claude).
# Run from a clone:  sh install.sh
# Or straight from GitHub:
#   curl -fsSL https://raw.githubusercontent.com/phuocs0n/claude-football-cosmos-themes/main/install.sh | sh
set -e
ids="albiceleste crimson-seventeen canary-samba cosmic-cliffs spartan-sunset"
raw="https://raw.githubusercontent.com/phuocs0n/claude-football-cosmos-themes/main/themes"
dest="$HOME/.claude/themes-for-claude"
here="$(cd "$(dirname "$0")" 2>/dev/null && pwd)/themes"
mkdir -p "$dest"
for id in $ids; do
  for ext in json css; do
    if [ -f "$here/$id.$ext" ]; then cp "$here/$id.$ext" "$dest/"; else curl -fsSL "$raw/$id.$ext" -o "$dest/$id.$ext"; fi
  done
  echo "installed $id"
done
echo "Done. In Claude Desktop, run /themes and pick a theme in the 'Yours' tab."
