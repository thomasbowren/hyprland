#!/usr/bin/env bash
# Show Hyprland keybinding cheatsheet in Rofi.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARSER="$SCRIPT_DIR/keybind-cheatsheet.py"
THEME="/home/Thomas/.local/share/rofi/themes/noctalia.rasi"

lines="$(python3 "$PARSER")"

if [ -z "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then
  printf '%s\n' "$lines"
  exit 0
fi

if [ -f "$THEME" ]; then
  printf '%s\n' "$lines" | rofi -dmenu -i -p "Keybinds" -theme "$THEME"
else
  printf '%s\n' "$lines" | rofi -dmenu -i -p "Keybinds"
fi
