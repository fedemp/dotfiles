return {
	"mcchrish/zenbones.nvim",
	dependencies = { 
		"rktjmp/lush.nvim"
	},
	priority = 1000,
	name = "zenbones",
	init = function() vim.cmd.colorscheme("zenbones") end
}
