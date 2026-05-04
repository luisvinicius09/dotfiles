local wezterm = require("wezterm")
local act = wezterm.action

local function is_found(str, pattern)
	return string.find(str, pattern) ~= nil
end

local function findPlatform()
	local is_win = is_found(wezterm.target_triple, "windows")
	local is_linux = is_found(wezterm.target_triple, "linux")
	local is_mac = is_found(wezterm.target_triple, "apple")

	local os = is_win and "windows" or is_linux and "linux" or is_mac and "mac" or "unknown"

	return {
		os = os,
		is_win = is_win,
		is_linux = is_linux,
		is_mac = is_mac,
	}
end

local platform = findPlatform()

local keysMapping = {}

local mod = {}

if platform.is_mac then
	mod.SUPER = "SUPER"
	mod.SUPER_REV = "SUPER|SHIFT"
elseif platform.is_win or platform.is_linux then
	mod.SUPER = "ALT" -- to not conflict with Windows key shortcuts
	mod.SUPER_REV = "ALT|CTRL"
end

-- Pane modifier: CMD on mac, CTRL|SHIFT on windows/linux
local pane_mod = platform.is_mac and "SUPER" or "CTRL|SHIFT"

keysMapping.keys = {
	-- Move forward by word
	{
		key = "RightArrow",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1bf"), -- Alt+f
	},
	-- Move backward by word
	{
		key = "LeftArrow",
		mods = "CTRL",
		action = wezterm.action.SendString("\x1bb"), -- Alt+b
	},

	-- For macOS users who prefer Option+Arrow
	{
		key = "RightArrow",
		mods = "OPT",
		action = wezterm.action.SendString("\x1bf"),
	},
	{
		key = "LeftArrow",
		mods = "OPT",
		action = wezterm.action.SendString("\x1bb"),
	},

	-- Delete previous word
	{
		key = "Backspace",
		mods = "CTRL",
		action = wezterm.action.SendString("\x17"), -- Ctrl+W
	},

	{
		key = "t",
		mods = mod.SUPER,
		action = act.SpawnCommandInNewTab({ cwd = wezterm.home_dir, domain = "DefaultDomain" }),
	},

	-- Pane: split vertical (side by side)
	{
		key = "|",
		mods = pane_mod,
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- Pane: split horizontal (on top of each other)
	{
		key = "-",
		mods = pane_mod,
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Pane: navigate with arrows
	{
		key = "LeftArrow",
		mods = pane_mod,
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = pane_mod,
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = pane_mod,
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = pane_mod,
		action = act.ActivatePaneDirection("Down"),
	},
	-- Pane: navigate with hjkl
	{
		key = "h",
		mods = pane_mod,
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = pane_mod,
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = pane_mod,
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = pane_mod,
		action = act.ActivatePaneDirection("Down"),
	},
	-- Pane: close
	{
		key = "w",
		mods = pane_mod,
		action = act.CloseCurrentPane({ confirm = false }),
	},
}

return keysMapping
