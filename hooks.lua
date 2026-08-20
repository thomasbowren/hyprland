--- Hooks and Callbacks ---

-- Create notification when submap is changed
hl.on("keybinds.submap", function(s)
	if s == "" then
		hl.notification.create({ text = "Universal keybinds active", timeout = 5000, icon = "ok" })
	else
		hl.notification.create({ text = s .. " submap active", timeout = 5000, icon = "ok" })
	end
end)
