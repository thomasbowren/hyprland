--------------------------------
---------- WINDOWS -------------
--------------------------------

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

----App-Specific Window-Rules----
hl.window_rule({
	name = "nemo_rule",
	match = {
		class = "nemo",
	},
	workspace = "3",
})

hl.window_rule({
	name = "tmux_rule",
	match = {
		class = "foot",
	},
	workspace = "4",
})

hl.window_rule({
	name = "neovim_rule",
	match = {
		class = "kitty",
	},
	workspace = "5",
})

hl.window_rule({
	name = "steam_rule",
	match = {
		class = "steam",
	},
	workspace = "7",
})

hl.window_rule({
	name = "chromium_rule",
	match = {
		class = "chromium",
	},
	workspace = "8",
})

hl.window_rule({
	name = "zen_rule",
	match = {
		class = "zen",
	},
	workspace = "8",
})

hl.window_rule({
	name = "youtube_rule",
	match = {
		class = "chrome-agimnkijcaahngcdmfeangaknmldooml-Default",
	},
	workspace = "6",
})

hl.window_rule({
	name = "vlc_rule",
	match = {
		class = "vlc",
	},
	workspace = "6",
})

hl.window_rule({
	name = "mpv_rule",
	match = {
		class = "mpv",
	},
	workspace = "6",
})

hl.window_rule({
	name = "music_rule",
	match = {
		class = "cider",
		float = false,
	},
	workspace = "9",
	opacity = "1.0 override 0.7 override 0.7 override",
})

hl.window_rule({
	name = "omatunes_rule",
	match = {
		class = "omatunes",
	},
	workspace = "9",
})

hl.window_rule({
	name = "podcast_rule",
	match = {
		class = "chrome-pocketcasts.com__podcasts-Default",
	},
	workspace = "9",
})

-- hl.window_rule({
-- 	name = "cider_miniPlayer_rule",
-- 	match = {
-- 		class = "Cider",
-- 		float = true,
-- 	},
-- 	persistent_size = true,
-- })

hl.window_rule({
	name = "imv_rule",
	match = {
		class = "imv",
	},
	float = true,
})

-- Set opacity of ghostty respective to its active, inactive, or fullscreen status
hl.window_rule({
	name = "ghostty_fullscreen_rule",
	match = { class = "com.mitchellh.ghostty" },
	opacity = "1.0 override 0.8 override 0.7 override",
})

-- Rule to correct pixelated fonts in Steam
hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})
--TODO: Create a dynamic tag dispatcher to trigger floating_rule
hl.window_rule({
	name = "floating_rule",
	match = {
		tag = "floating_window*",
	},
	float = true,
})
