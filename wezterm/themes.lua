local wezterm = require("wezterm")
local act = wezterm.action

-- Reference: https://github.com/andrewberty/dotfiles/blob/main/wezterm/features.lua

function themes()
	return wezterm.action_callback(function(window, pane)
		local choices = {}

		local schemes = wezterm.get_builtin_color_schemes()
		local custom_schemes_path = wezterm.glob(wezterm.config_dir .. "/colors/*")

		-- loop over builtin schemes
		for scheme, _ in pairs(schemes) do
			table.insert(choices, { label = tostring(scheme) })
		end

		-- loop over custom schemes in {config dir}/colors
		for _, scheme in pairs(custom_schemes_path) do
			local scheme_name = utils.getDirNameFromPath(scheme):gsub(".toml", "")
			table.insert(choices, { label = tostring(scheme_name) })
		end

		-- sort choices list
		table.sort(choices, function(c1, c2)
			return c1.label < c2.label
		end)

		local action = wezterm.action_callback(function(_, _, _, label)
			if label then
				globals.setGlobals(function(G)
					G.colorscheme = label
				end)
			end
		end)

		local opts = {
			window = window,
			pane = pane,
			choices = choices,
			title = wezterm.format({
				{ Attribute = { Underline = "Single" } },
				{ Foreground = { AnsiColor = "Green" } },
				{ Text = "Choose a theme! 🎨" },
			}),
			action = action,
		}

		picker.pick(opts)
	end)
end

return themes
