local mainMod = "SUPER"
local shiftMod = mainMod .. " + SHIFT"
local altMod = mainMod .. " + ALT"

-- Use special workspace to mimic the "minimize window" function by using a single keybind to toggle the minimized state.
hl.bind(altMod .. " + M", function()
	if hl.get_workspace("special:minimized") then
		hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
		hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
	else
		hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
		hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
	end
end)

-- Cycle through layout modes
hl.bind(altMod .. " + L", function()
	local layouts = { "scrolling", "dwindle", "master", "monocle" }
	local workspace = hl.get_active_workspace()
	if hl.get_active_special_workspace() then
		workspace = hl.get_active_special_workspace()
	end

	local next_layout = "dwindle"

	if not workspace then
		return
	end

	for i = 1, #layouts do
		if layouts[i] == workspace.tiled_layout then
			local next_layout_idx = (i % #layouts) + 1
			next_layout = layouts[next_layout_idx]
			break
		end
	end

	if workspace.special then
		hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
	else
		hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
	end
end)

-- Bind to use cursor zoom like a glass magnifier
local MAX_ZOOM = 3
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1.5

---@param offset number
---@return nil
local function zoom(offset)
	local current = hl.get_config("cursor.zoom_factor")
	if offset ~= nil then
		current = current + offset
	elseif current ~= MIN_ZOOM then
		current = MIN_ZOOM
	else
		current = ZOOM_TOGGLE_FACTOR
	end
	current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
	hl.config({ cursor = { zoom_factor = current } })
end

hl.bind("SUPER + Z", zoom)
hl.bind("SUPER + KP_ADD", function()
	zoom(0.5)
end)
hl.bind("SUPER + KP_SUBTRACT", function()
	zoom(-0.5)
end)

-- Bind to different actions to same keybindings based on current layout modelocal function layout_bind(bind_table)
local function layout_bind(bind_table)
	return function()
		local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()

		if not workspace then
			return
		end

		local layout = workspace.tiled_layout

		if bind_table[layout] then
			hl.dispatch(bind_table[layout])
		end
	end
end

hl.bind(
	shiftMod .. " + slash",
	layout_bind({
		scrolling = hl.dsp.layout("swapcol l"), -- Scrolling: swap column with left one
		dwindle = hl.dsp.layout("swapsplit"), -- Dwindle: swap window split
		monocle = hl.dsp.layout("cycleprev"), -- Monocle and master: cycle prev window
		master = hl.dsp.layout("cycleprev"),
	})
)

hl.bind(
	mainMod .. " + slash",
	layout_bind({
		scrolling = hl.dsp.layout("swapcol r"), -- Scrolling: swap column with right one
		dwindle = hl.dsp.layout("togglesplit"), -- Dwindle: toggle window split
		monocle = hl.dsp.layout("cyclenext"), -- Monocle and master: cycle next window
		master = hl.dsp.layout("cyclenext"),
	})
)
