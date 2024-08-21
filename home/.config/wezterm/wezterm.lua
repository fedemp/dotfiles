local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("Hack")
config.font_size = 14

config.use_fancy_tab_bar = true

config.window_padding = {
	left = 2,
	right = 2,
	top = 0,
	bottom = 0,
}

config.window_decorations = "RESIZE"

-- local scheme = "ubuntu"
-- local scheme = "Alabaster"
-- local scheme = "ayu_light"
local scheme = "dawnfox"

-- Obtain the definition of that color scheme
local scheme_def = wezterm.color.get_builtin_schemes()[scheme]

config.color_scheme = scheme
config.colors = {
	tab_bar = {
		active_tab = {
			bg_color = scheme_def.background,
			fg_color = scheme_def.foreground,
		},
	},
}

return config
