local mainMod = "SUPER"
local ctrlMod = "SUPER + CTRL"
-- Submap to resize windows with arrow keys. Switch to a submap called `resize`.
hl.bind(mainMod .. " + R", hl.dsp.submap("Resize"))

-- Start a submap called "resize".
hl.define_submap("Resize", function()
	-- Set repeating binds for resizing the active window.
	hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
	hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
	hl.bind("up", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
	hl.bind("down", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })

	-- Use `reset` to go back to the global submap
	hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Launch a submap to disable all hyprland keybindings
hl.bind(ctrlMod .. " + home", hl.dsp.submap("Clean"))
hl.define_submap("Clean", function()
	hl.bind("escape", hl.dsp.submap("reset"))
end)
-- Keybinds further down will be global again..r

-- Scroll Overview plugin
hl.define_submap("scrolloverview", function()
	hl.bind("left", hl.plugin.scrolloverview.navigate("left"))
	hl.bind("right", hl.plugin.scrolloverview.navigate("right"))
	hl.bind("up", hl.plugin.scrolloverview.navigate("up"))
	hl.bind("down", hl.plugin.scrolloverview.navigate("down"))
	hl.bind("return", hl.plugin.scrolloverview.overview("select"))
	hl.bind("escape", hl.plugin.scrolloverview.overview("off"))
	hl.bind("mouse:272", function()
		-- Select the clicked window, or just the workspace if no window was clicked, then close the overview. This is the default behaviour if submap is not defined.
		hl.plugin.scrolloverview.overview("select")
		hl.plugin.scrolloverview.window("select")
		hl.plugin.scrolloverview.overview("off")
	end, { mouse = true })
	hl.bind("mouse:274", hl.plugin.scrolloverview.window("close"), { mouse = true })
end)
