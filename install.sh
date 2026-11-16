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
# /themes as a command file too: the mod registers /themes only once a chat has started, so a new chat's slash menu
# did not list it; with this file every chat lists it, and the mod's own hook still answers it with the theme strip
mkdir -p "$HOME/.claude/commands"
cmd="$(dirname "$here")/commands/themes.md"
if [ -f "$cmd" ]; then cp "$cmd" "$HOME/.claude/commands/"; else curl -fsSL "${raw%/themes}/commands/themes.md" -o "$HOME/.claude/commands/themes.md"; fi
echo "installed the /themes command"
echo "Done. In Claude Desktop, run /themes and pick a theme in the 'Yours' tab."
