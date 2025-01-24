return {
	"echasnovski/mini.pick",
	version = false,
	event = "VeryLazy",
	opts = {
		mappings = {
			choose_all = {
				char = "<C-q>",
				func = function()
					local mappings = MiniPick.get_picker_opts().mappings
					vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
				end,
			},
		},
	},
	keys = {
		{ "<Leader><Leader>", "<cmd>Pick files<cr>" },
		{ "<Leader>g", "<cmd>Pick grep<cr>" },
		{ "<Leader>b", "<cmd>Pick buffers<cr>" },
	},
}
