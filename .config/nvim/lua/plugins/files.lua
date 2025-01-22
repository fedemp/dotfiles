return {
	"echasnovski/mini.files",
	version = false,
	event = "VeryLazy",
	opts = {},
	keys = {
		{ "-", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>" },
	},
}
