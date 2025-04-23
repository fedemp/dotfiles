local add, now = MiniDeps.add, MiniDeps.now

now(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "master",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})

	add("nvim-treesitter/nvim-treesitter-textobjects")

	---@diagnostic disable-next-line: missing-fields
	require("nvim-treesitter.configs").setup({
		highlight = {
			enable = true,
		},
		indent = { enable = false },
		ensure_installed = {
			"json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"graphql",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"vimdoc",
		},
		incremental_selection = {
			enable = false,
		},
	})

	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end)
