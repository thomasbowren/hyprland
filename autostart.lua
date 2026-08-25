--- Hyprland startup actions ---
hl.on("hyprland.start", function()
	-- hl.exec_cmd("noctalia")
  hl.exec_cmd("solaar")
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 30")
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("foot --server")
	hl.exec_cmd("tmux vibez")
end)
