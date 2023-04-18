local colors_name = "apprenbones"
vim.g.colors_name = colors_name -- Required when defining a colorscheme

local lush = require("lush")
local hsluv = lush.hsluv -- Human-friendly hsl
local util = require("zenbones.util")

local bg = vim.o.background

-- Define a palette. Use `palette_extend` to fill unspecified colors
-- Based on https://github.com/gruvbox-community/gruvbox#palette
local palette
if bg == "light" then
	palette = util.palette_extend({
		bg = hsluv("#bcbcbc"),
		fg = hsluv("#262626"),
		rose = hsluv("#af5f5f"),
		leaf = hsluv("#5f875f"),
		wood = hsluv("#87875f"),
		water = hsluv("#5f87af"),
		blossom = hsluv("#5f5f87"),
		sky = hsluv("#5f8787"),
	}, bg)
else
	palette = util.palette_extend({
		bg = hsluv("#262626"),
		fg = hsluv("#bcbcbc"),
		rose = hsluv("#af5f5f"),
		leaf = hsluv("#5f875f"),
		wood = hsluv("#87875f"),
		water = hsluv("#5f87af"),
		blossom = hsluv("#5f5f87"),
		sky = hsluv("#5f8787"),
	}, bg)
end

-- Generate the lush specs using the generator util
local generator = require("zenbones.specs")
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

-- Optionally extend specs using Lush
local specs = lush.extends({ base_specs }).with(function()
	return {
		Statement({ base_specs.Statement, fg = palette.water }),
		Special({ fg = palette.water }),
		Type({ fg = palette.sky }),
		String({ fg = palette.leaf, gui = "normal" }),
	}
end)

-- Pass the specs to lush to apply
lush(specs)

-- Optionally set term colors
require("zenbones.term").apply_colors(palette)
