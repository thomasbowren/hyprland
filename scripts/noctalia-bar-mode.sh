#!/usr/bin/env bash
# Toggle the Noctalia bar between two modes:
#   docked: always visible, reserves space for windows
#   smart:  smart auto-hide (hide while the workspace has windows), no reserved space
#
# Both settings are written together to one drop-in config file. Noctalia
# hot-reloads ~/.config/noctalia/*.toml, so auto-hide and reserve can never
# drift apart, and the mode survives shell restarts, config reloads and reboots.
# (The runtime IPC commands bar-auto-hide-set / bar-reserve-toggle are reset by
# any config reload, which is what caused the old keybind to desync.)
set -euo pipefail

conf_dir="${XDG_CONFIG_HOME:-$HOME/.config}/noctalia"
conf="$conf_dir/bar-mode.toml"
bar="${1:-default}"

mkdir -p "$conf_dir"

# Serialize rapid key presses
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/noctalia-bar-mode.lock"
flock 9

if grep -qs '^smart_auto_hide = true' "$conf"; then
	smart=false reserve=true
else
	smart=true reserve=false
fi

# Write to a non-.toml temp name, then rename, so Noctalia only ever sees a complete file
tmp="$(mktemp "$conf_dir/.bar-mode.XXXXXX")"
cat >"$tmp" <<EOF
# Managed by ~/.config/hypr/scripts/noctalia-bar-mode.sh (SUPER+CTRL+ALT+SPACE)
[bar.$bar]
auto_hide = false
smart_auto_hide = $smart
reserve_space = $reserve
EOF
mv -f "$tmp" "$conf"
