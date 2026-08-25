------------------------
------- KEYBINDINGS ----
------------------------
---
-- Modifier keys
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local shiftMod = mainMod .. " + SHIFT" -- Sets Shift key as secondary modifier
local altMod = mainMod .. " + ALT" -- Sets Alt key as alternative modifier for launching secondary configurations of defaults
local altShiftMod = shiftMod .. " + ALT" -- Sets Alt key as tertiary modifier
local ctrlMod = mainMod .. " + CTRL" -- Sets Ctrl key as system services primary keybinding
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
----- closeWindowBind:set_enabled(false)
---
hl.bind(
	mainMod .. " + delete + end",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
---hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
----- hl.unbind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
---hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
---hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
---
----- Move focus with mainMod + arrow keys
---hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
---hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
---hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
---hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
---hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
---hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
---hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
---hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
---
----- Move windows with shiftMod + arrow keys
---hl.bind(shiftMod .. " + left", hl.dsp.window.move({ direction = "left" }), { description = "Move window to the left" })
---hl.bind(
---	shiftMod .. " + right",
---	hl.dsp.window.move({ direction = "right" }),
---	{ description = "Move window to the right" }
---)
---hl.bind(shiftMod .. " + up", hl.dsp.window.move({ direction = "up" }), { description = "Move window up" })
---hl.bind(shiftMod .. " + down", hl.dsp.window.move({ direction = "down" }), { description = "Move window down" })
---
----- Switch workspaces with mainMod + [0-9]
----- Move active window to a workspace with mainMod + SHIFT + [0-9]
---for i = 1, 10 do
---	local key = i % 10 -- 10 maps to key 0
---	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { submap_universal = true })
---	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { submap_universal = true })
---end
---
----- Example special workspace (scratchpad)
---hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
---hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
---
----- Scroll through existing workspaces with mainMod + scroll
---hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
---hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
---
----- Scroll though existing workspaces with shiftMod + TAB
---hl.bind(shiftMod .. " + TAB", hl.dsp.focus({ workspace = "e+1" }))
---
----- Cycle to next window on current workspace
---hl.bind(mainMod .. " + TAB", function()
---	hl.dispatch(hl.dsp.window.cycle_next())
---	hl.dispatch(hl.dsp.window.bring_to_top())
---end, { description = "Cycle to next window and/or bring window to top" })
---
----- To switch between windows in a floating workspace:
----- hl.bind("SUPER + Tab", function()
----- 	hl.dispatch(hl.dsp.window.cycle_next()) -- Change focus to another window
----- 	hl.dispatch(hl.dsp.window.bring_to_top()) -- Bring it to the top
----- end)
---
----- Move/resize windows with mainMod + LMB/RMB and dragging
---hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
---hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
---
--------- Laptop multimedia keys for volume and LCD brightness
---hl.bind(
---	"XF86AudioRaiseVolume",
---	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
---	{ locked = true, repeating = true }
---)
---hl.bind(
---	"XF86AudioLowerVolume",
---	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
---	{ locked = true, repeating = true }
---)
---hl.bind(
---	"XF86AudioMute",
---	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
---	{ locked = true, repeating = true }
---)
---hl.bind(
---	"XF86AudioMicMute",
---	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
---	{ locked = true, repeating = true }
---)
---hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
---hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
---
----- Requires playerctl
---hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
---hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
---hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
---hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
---
----- wl-clipboard universal COPY/PASTE
---hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("wl-copy"), { description = "Copy Command" })
---hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("wl-paste"), { description = "Paste Command" })
---
-- Set programs that you use
local terminal = "ghostty"
local fileManager = "yazi"
local browser = "zen-browser"
local editor = "nvim"
local music_player = "sh.cider.Cider"
-- local runner = "rofi -show run"
local AirDrop = "localsend"
-- local streaming_service = "chrome-agimnkijcaahngcdmfeangaknmldooml-Default" --Youtube
local email = " https://mail.google.com/mail/u/0/?tab=rm&ogbl#inbox" -- Gmail
local webapp = "gtk-launch "
---
----- Apps
-- hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal), { description = "Default Terminal" })
hl.bind(
	altMod .. " + RETURN",
	hl.dsp.exec_cmd("foot tmux new-session -A -s default"),
	{ description = "Launch Tmux inside Foot" }
)
-- hl.bind(shiftMod .. " + B", hl.dsp.exec_cmd(browser), { description = "Default Browser" })
hl.bind(
	altShiftMod .. " + B",
	hl.dsp.exec_cmd(browser .. " --private-window https://duckduckgo.com"),
	{ description = "Private Browser" }
)
hl.bind(ctrlMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a"), { description = "Color Picker" })
hl.bind(shiftMod .. " + F", hl.dsp.exec_cmd(terminal .. " -e " .. fileManager), { description = "File Manager" })
hl.bind(shiftMod .. " + N", hl.dsp.exec_cmd("kitty" .. " -e " .. editor), { description = "Default Editor" })
hl.bind(ctrlMod .. " + L", hl.dsp.exec_cmd(AirDrop), { description = "AirDrop Alternative" })
hl.bind(shiftMod .. " + M", hl.dsp.exec_cmd(music_player), { description = "Music Player" })
hl.bind(shiftMod .. " + T", hl.dsp.exec_cmd(terminal .. " -e " .. "btop"), { description = "Resource Monitor" })

-- Webapps
hl.bind(shiftMod .. " + E", hl.dsp.exec_cmd("chromium" .. email), { description = "Email" })
-- hl.bind(
-- 	shiftMod .. " + R",
-- 	hl.dsp.exec_cmd(webapp .. "chrome-lgnggepjiihbfdbedefdhcffnmhcahbm-Default"),
-- 	{ description = "Reddit" }
-- )
-- hl.bind(
-- 	shiftMod .. " + Y",
-- 	hl.dsp.exec_cmd(webapp .. streaming_service),
-- 	{ description = "Web video streaming service" }
-- )
hl.bind(shiftMod .. " + P", hl.dsp.exec_cmd("omarchy-launch-webapp https://pocketcasts.com/podcasts"), { description = "Podcasts" })
-- hl.bind(shiftMod .. " + W", hl.dsp.exec_cmd(webapp .. "WGU"), { description = "WGU Student Portal" })

-- rofi
-- hl.bind(shiftMod .. " + SPACE", hl.dsp.exec_cmd(runner), { description = "Run system commands from launcher" })

-- Plugins
hl.bind(mainMod .. " + M", function()
	hl.plugin.scrolloverview.overview("toggle")
end, { submap_universal = true })
