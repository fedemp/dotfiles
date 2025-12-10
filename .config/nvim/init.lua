--------------
-- SETTINGS --
--------------
vim.o.title = true          -- Update window title.
vim.o.colorcolumn = "+1"    -- Visible column
vim.o.cursorline = true     -- Enable highlighting of the current line
vim.o.inccommand = "split"  -- Show global changes when doing search and replace
vim.o.number = true         -- Show line numbers
vim.o.shiftwidth = 4        -- Indent width
vim.o.tabstop = 4           -- Tab width
vim.o.ignorecase = true     -- Ignore case
vim.o.smartcase = true      -- Better ignorecase
vim.o.infercase = true      -- Better completion
vim.o.swapfile = false      -- Turn off swapfile
vim.o.scrolloff = 8         -- Always show 8 lines before cursor touches top or bottom
vim.o.undofile = true       -- Enable persistent undo
vim.o.confirm = true        -- Confirm unsaved
vim.o.mouse = ""            -- No mouse
vim.o.winborder = "rounded" -- Rounded floats
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" } -- Always show menu, don't autoselect
vim.opt.cursorlineopt = { "screenline",


	"number" } -- Highligth current screen line only

vim.diagnostic.config({
	virtual_text = {
		current_line = true,
	},
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "󰠠",
			[vim.diagnostic.severity.INFO] = "",
		},
	},
})

--------------
-- MAPPINGS --
--------------
vim.keymap.set({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, desc = "j iterates screen lines" })
vim.keymap.set({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, desc = "k iterates screen lines" })

vim.keymap.set("n", "U", "", { noremap = true, silent = true, desc = "Redo" }) -- u undoes, U redoes

vim.keymap.set("n", "J", "mzJ`z", { desc = "Restore position after joining lines" })
-- vim.keymap.set("v", "y", "mqy`q", { desc = "Restore position after yanking" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center cursor line after jumping" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center cursor line after jumping" })

vim.keymap.set("n", "<BS>", "", { desc = "Go to alternate buffer" })

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Easy normal mode in terminal" })

----------------
-- TREESITTER --
----------------
vim.pack.add({ {
	src = "https://github.com/nvim-treesitter/nvim-treesitter",
	version = "main",
} })
require("nvim-treesitter").install({
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
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "<filetype>" },
	callback = function()
		vim.treesitter.start()
	end,
})

vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- LSP folds are enabled below.

---------
-- LSP --
---------
vim.pack.add({ "https://github.com/williamboman/mason.nvim" })
vim.pack.add({ "https://github.com/williamboman/mason-lspconfig.nvim" })
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

require("mason").setup()
require("mason-lspconfig").setup()

vim.lsp.enable({ "tsgo", "tailwindcss", "lua_ls", "biome" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		-- Enable folding
		if client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end

		if not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({
						timeout_ms = 1000,
						filter = function(client) return client.name ~= "tsgo" end
					})
				end,
			})
		end

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		-- if client:supports_method("textDocument/completion") then
		-- 	vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		-- end
	end,
})

-------------
-- PLUGINS --
-------------
vim.pack.add({ { src = "https://github.com/nvim-mini/mini.nvim", version = "main" } })
require("mini.notify").setup({
	window = { config = { border = "double" } },
})
vim.notify = MiniNotify.make_notify()

require("mini.icons").setup()
MiniIcons.tweak_lsp_kind()

require("mini.jump").setup()

require("mini.misc").setup()
MiniMisc.setup_termbg_sync()

vim.pack.add({ "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" })
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

require("mini.files").setup()
vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>", { desc = "File directory" })

-- vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
-- require("conform").setup({
-- 	formatters_by_ft = {
-- 		typescript = { "biome", stop_after_first = true },
-- 		typescriptreact = { "biome", stop_after_first = true },
-- 		javascript = { "biome", stop_after_first = true },
-- 		json = { "biome", stop_after_first = true },
-- 		css = { "biome", stop_after_first = true },
-- 	},
-- 	format_on_save = {
-- 		-- These options will be passed to conform.format()
-- 		timeout_ms = 5000,
-- 		lsp_format = "fallback",
-- 	},
-- })
-- vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

require("mini.pick").setup()
vim.ui.select = MiniPick.ui_select
vim.keymap.set("n", "<Leader><Leader>", "<cmd>Pick files<cr>", { desc = "Files" })
vim.keymap.set("n", "<Leader>g", "<cmd>Pick grep_live<cr>", { desc = "Grep live" })
vim.keymap.set("n", "<Leader>b", "<cmd>Pick buffers<cr>", { desc = "Buffers" })

require("mini.surround").setup()

require("mini.animate").setup();

require("mini.completion").setup()
vim.o.pumborder = "rounded"

-- vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim" })
-- require("toggleterm").setup({
-- 	open_mapping = [[<c-\>]],
-- 	shade_terminals = false,
-- 	terminal_mappings = true,
-- 	direction = "vertical",
-- })

------------------
-- COLORSCHEMES --
------------------
vim.pack.add({
	"https://github.com/pebeto/dookie.nvim", -- Acme clone
	"https://github.com/e-q/okcolors.nvim",
	"https://github.com/yorik1984/newpaper.nvim",
	"https://github.com/xeind/nightingale.nvim",
	"https://github.com/ramojus/mellifluous.nvim",
	"https://github.com/miikanissi/modus-themes.nvim",
	"https://github.com/EdenEast/nightfox.nvim",
	"https://github.com/rebelot/kanagawa.nvim",
})

vim.cmd.colorscheme("minisummer")
