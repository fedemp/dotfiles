local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	require("mini.notify").setup({
		window = { config = { border = "double" } },
	})
	vim.notify = MiniNotify.make_notify()
end)

now(function()
	require("mini.icons").setup()
	later(MiniIcons.tweak_lsp_kind)
end)

later(function()
	require("mini.bufremove").setup()
end)

later(function()
	local ai = require("mini.ai")
	ai.setup({
		custom_textobjects = {
			F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
		},
	})
end)

later(function()
	require("mini.jump").setup()
end)

later(function()
	require("mini.misc").setup()
	MiniMisc.setup_termbg_sync()
end)

later(function()
	add("JoosepAlviste/nvim-ts-context-commentstring")
	require("ts_context_commentstring").setup({
		enable_autocmd = false,
	})
	require("mini.comment").setup({
		options = {
			custom_commentstring = function()
				return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
			end,
		},
	})
end)

later(function()
	add("stevearc/dressing.nvim")
	require("dressing").setup()
end)

later(function()
	require("mini.files").setup()
end)

later(function()
	add("stevearc/conform.nvim")
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			graphql = { "prettier", stop_after_first = true },
			typescript = { "biome", stop_after_first = true },
			typescriptreact = { "biome", stop_after_first = true },
			javascript = { "biome", stop_after_first = true },
			json = { "biome", stop_after_first = true },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 5000,
			lsp_format = "never",
		},
	})
	vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
end)

later(function()
	require("mini.pick").setup({
		mappings = {
			choose_all = {
				char = "<C-q>",
				func = function()
					local mappings = MiniPick.get_picker_opts().mappings
					vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
				end,
			},
		},
	})
	vim.ui.select = MiniPick.ui_select
end)

later(function()
	require("mini.surround").setup()
end)

later(function()
	add("akinsho/toggleterm.nvim")
	require("toggleterm").setup({
		open_mapping = [[<c-\>]],
		shade_terminals = false,
		terminal_mappings = true,
		direction = "vertical",
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.4
			end
		end,
	})
end)

later(function()
	local process_items = function(items, base)
		-- Don't show 'Text' suggestions
		items = vim.tbl_filter(function(x)
			return x.kind ~= 1
		end, items)
		return MiniCompletion.default_process_items(items, base)
	end
	require("mini.completion").setup({
		lsp_completion = {
			source_func = "omnifunc",
			auto_setup = false,
			process_items = process_items,
		},
		window = {
			info = { border = "double" },
			signature = { border = "double" },
		},
	})
	if vim.fn.has("nvim-0.11") == 1 then
		vim.opt.completeopt:append("fuzzy") -- Use fuzzy matching for built-in completion
	end
end)

later(function()
	add("rafamadriz/friendly-snippets")
	require("mini.snippets").setup()
end)
