--------------------------------
--------- WORKSPACES -----------
--------------------------------

-- Example workspace rules that are useful
hl.workspace_rule({ workspace = "1", monitor = "DP-3", persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-3", persistent = true })
-- hl.workspace_rule({ workspace = "3", monitor = "DP-3", persistent = true })
-- hl.workspace_rule({ workspace = "4", monitor = "DP-3", persistent = true })
-- hl.workspace_rule({ workspace = "5", monitor = "DP-3", persistent = true })

-- Default apps to launch per given workspace
hl.workspace_rule({ workspace = "3", on_created_empty = "kitty -e yazi" })
hl.workspace_rule({ workspace = "4", on_created_empty = "ghostty" })
hl.workspace_rule({ workspace = "5", on_created_empty = "kitty -e nvim" })
hl.workspace_rule({ workspace = "6", on_created_empty = "vlc" })
hl.workspace_rule({ workspace = "7", on_created_empty = "steam" })
hl.workspace_rule({ workspace = "8", on_created_empty = "zen-browser" })
hl.workspace_rule({ workspace = "9", on_created_empty = "sh.cider.Cider" })
