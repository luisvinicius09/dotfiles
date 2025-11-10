local wezterm = require("wezterm")
local keybinds = require("keybinds")

-- Reference: https://github.com/andrewberty/dotfiles/blob/main/wezterm/fonts.lua

local config = wezterm.config_builder()

config.default_cwd = wezterm.home_dir

config.font = wezterm.font("JetBrains Mono", {})
config.font_size = 12

config.keys = keybinds.keys

-- config.color_scheme = "GruvboxDark"
config.color_scheme = "Tokyo Night Storm (Gogh)"

config.initial_cols = 120
config.initial_rows = 40

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.window_decorations = "RESIZE"
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false

return config
