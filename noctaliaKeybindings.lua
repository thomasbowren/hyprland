local mainMod = "SUPER"
local shiftMod = mainMod .. " + SHIFT"
local altMod = mainMod .. " + ALT"
local ctrlMod = mainMod .. " + CTRL"
local ctrlShiftMod = ctrlMod .. " + SHIFT"
local ipc = "noctalia msg"

-- Core binds
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"))
hl.bind(mainMod .. " + ALT + SPACE", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(ipc .. " settings-toggle"))

-- Settings toggles
-- hl.bind(
-- 	shiftMod .. " + CTRL + W",
-- 	hl.dsp.exec_cmd(ipc .. " settings-toggle wallpaper"),
-- 	{ description = "Wallpaper Menu" }
-- )

-- Panel toggles
hl.bind(
	mainMod .. " + CTRL + M",
	hl.dsp.exec_cmd(ipc .. " panel-toggle control-center media"),
	{ description = "Toggle Music Panel" }
)
hl.bind(
	mainMod .. " + CTRL + SPACE",
	hl.dsp.exec_cmd(ipc .. " panel-toggle wallpaper"),
	{ description = "Wallpaper Selector" }
)
hl.bind(
	mainMod .. " + CTRL + v",
	hl.dsp.exec_cmd(ipc .. " panel-toggle clipboard"),
	{ description = "Preview Clipboard" }
)
hl.bind(mainMod .. " + escape", hl.dsp.exec_cmd(ipc .. " panel-toggle session"), { description = "Session Menu" })
hl.bind(
	mainMod .. " + CTRL + B",
	hl.dsp.exec_cmd(ipc .. " panel-toggle control-center bluetooth"),
	{ description = "Preview Bluetooth" }
)
hl.bind(
	mainMod .. " + CTRL + N",
	hl.dsp.exec_cmd(ipc .. " panel-toggle control-center network"),
	{ description = "Preview Network Connection" }
)
hl.bind(
	mainMod .. " + CTRL + W",
	hl.dsp.exec_cmd(ipc .. " panel-toggle control-center weather"),
	{ description = "Preview Weather" }
)

-- Bar: smart auto-hide <-> docked + reserved space, persisted in ~/.config/noctalia/bar-mode.toml
hl.bind(
	mainMod .. " + CTRL + ALT + SPACE",
	hl.dsp.exec_cmd("/home/Thomas/.config/hypr/scripts/noctalia-bar-mode.sh"),
	{ description = "Auto-Hide Bar" }
)

-- Bar (IPC + state file version, desyncs whenever Noctalia reloads its config)
-- hl.bind(
-- 	mainMod .. " + CTRL + ALT + SPACE",
-- 	hl.dsp.exec_cmd(
-- 		[[bash -c 'S="${XDG_RUNTIME_DIR:-/tmp}/noctalia-bar-autohide.state"; if [ "$(cat "$S" 2>/dev/null)" = "smart" ]; then noctalia msg bar-auto-hide-set off && noctalia msg bar-reserve-toggle && echo off > "$S"; else noctalia msg bar-auto-hide-set smart && noctalia msg bar-reserve-toggle && echo smart > "$S"; fi']]
-- 	),
-- 	{ description = "Auto-Hide Bar" }
-- )

-- Bar (legacy version)
-- local bar_hidden = false
-- hl.bind(mainMod .. " + CTRL + ALT + SPACE", function()
-- 	if bar_hidden == false then
-- 		hl.dispatch(hl.dsp.exec_cmd(ipc .. " bar-auto-hide-set smart"))
-- 		bar_hidden = true
-- 	else
-- 		hl.dispatch(hl.dsp.exec_cmd(ipc .. " bar-auto-hide-set off"))
-- 		bar_hidden = false
-- 	end
-- 	hl.dispatch(hl.dsp.exec_cmd(ipc .. " bar-reserve-toggle"))
-- end, { description = "Auto-Hide Bar" })

-- Widgets

-- Bluetooth toggle
hl.bind(shiftMod .. " + CTRL + B", hl.dsp.exec_cmd(ipc .. " bluetooth-toggle"), { description = "Toggle Bluetooth" })

-- Clipboard
hl.bind(ctrlShiftMod .. " + D", hl.dsp.exec_cmd(ipc .. " clipboard-clear"), { description = "Clear clipboard history" })

-- Idle inhibit
hl.bind(mainMod .. " + CTRL + i", hl.dsp.exec_cmd(ipc .. " caffeine-toggle"), { description = "Inhibit Idle State" })

-- Screen capture
hl.bind("Print", hl.dsp.exec_cmd(ipc .. " screenshot-region"), { description = "Region Capture" })
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(ipc .. " screenshot-fullscreen"), { description = "Fullscreen Capture" })

-- Media keys
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. " brightness-up"), { description = "Brightness-Up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness-down"), { description = "Brightness-Down" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume-up"), { description = "Volume-Up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume-down"), { description = "Volume-Down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume-mute"), { description = "Volume-Mute" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. " media toggle"), { description = "Play/Pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. " media next"), { description = "Next Track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. " media previous"), { description = "Previous Track" })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(ipc .. " media stop"), { description = "Stop" })

-- Wifi toggle
hl.bind(
	shiftMod .. " + CTRL + W",
	hl.dsp.exec_cmd(ipc .. " wifi-toggle"),
	{ description = "Set background to a random wallpaper from current theme" }
)
-- Window switcher
hl.bind("ALT + TAB", hl.dsp.exec_cmd(ipc .. " window-switcher"), { description = "ALT-TAB Style window-switching" })
hl.bind("ALT + TAB + Q", hl.dsp.exec_cmd(ipc .. " window-switcher hide"), { description = "Hide window-switcher" })

-- Plugins

-- Screen Recorder
hl.bind(
	ctrlMod .. " + C",
	hl.dsp.exec_cmd(ipc .. " plugin noctalia/screen_recorder:service all toggle"),
	{ description = "Toggle Noctalia Screen Recorder" }
)

-- Timer
hl.bind(
	ctrlMod .. " + T",
	hl.dsp.exec_cmd(ipc .. " panel-toggle noctalia/timer:panel"),
	{ description = "Toggle Noctalia Screen Recorder" }
)

-- Wallpaper
hl.bind(
	shiftMod .. " + CTRL + SPACE",
	hl.dsp.exec_cmd(ipc .. " wallpaper-random"),
	{ description = "Set background to a random wallpaper from current theme" }
)
