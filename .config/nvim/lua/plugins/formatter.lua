return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd", stop_after_first = true },
			typescript = { "prettierd", stop_after_first = true },
			typescriptreact = { "prettierd", stop_after_first = true },
			html = { "prettierd", stop_after_first = true },
			json = { "prettierd", stop_after_first = true },
			graphql = { "prettierd", stop_after_first = true },
			scss = { "prettierd", stop_after_first = true },
			css = { "prettierd", stop_after_first = true },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 5000,
			lsp_format = "fallback",
		},
	},
	init = function() vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()" end
}
