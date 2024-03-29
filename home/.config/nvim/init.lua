-- SETTINGS
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.inccommand = "split"
vim.opt.number = true
vim.opt.shell = "zsh"
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.signcolumn = "number"
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.textwidth = 79
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.scrolloff = 8
vim.opt.diffopt =
	{ "filler", "iwhiteall", "vertical", "hiddenoff", "closeoff", "hiddenoff", "algorithm:histogram", "linematch:60" }
vim.opt.listchars =
	{ eol = "↵", tab = "¬ ", lead = "·", trail = "·", extends = "◣", precedes = "◢", nbsp = "␣" }
vim.opt.list = false
vim.opt.wildignore:append({ "*/dist/*", "*/min/*", "*/vendor/*", "*/node_modules/*", "*/bower_components/*" })
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- PLUGINS
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"tpope/vim-fugitive",

	"kaarmu/typst.vim",

	{
		"chomosuke/typst-preview.nvim",
		lazy = false, -- or ft = 'typst'
		version = "0.1.*",
		build = function()
			require("typst-preview").update()
		end,
	},

	-- "folke/which-key.nvim",

	-- "onsails/lspkind.nvim",

	{ "echasnovski/mini.surround", config = true },

	-- {
	-- 	"gbprod/nord.nvim",
	-- 	opts = {},
	-- },

	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	opts = {},
	-- },

	{
		"mcchrish/zenbones.nvim",
		priority = 1000,
		lazy = false,
		dependencies = { "rktjmp/lush.nvim" },
		config = function()
			vim.cmd.colorscheme("tokyobones")
		end,
	},

	{
		"stevearc/oil.nvim",
		opts = {
			skip_confirm_for_simple_edits = true,
		},
	},

	{
		"stevearc/dressing.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			select = {
				backend = { "telescope" },
			},
		},
	},

	{
		"akinsho/toggleterm.nvim",
		opts = {
			open_mapping = [[<c-\>]],
			shade_terminals = false,
			terminal_mappings = true,
		},
	},

	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					{
						"mode",
						icons_enabled = true,
						colors = { gui = "bold" },
					},
				},
				lualine_b = { "filename" },
				lualine_c = { { "diagnostics", icons_enabled = false } },
				lualine_x = {
					"branch",
					{
						"diff",
						colored = true, -- Displays a colored diff status if set to true
						symbols = { added = "+", modified = "±", removed = "-" }, -- Changes the symbols used by the diff.
					},
				},
				lualine_y = { "filetype" },
				lualine_z = { "progress" },
			},
		},
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	},

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "lua", "tsx", "javascript", "typescript", "vimdoc", "vim", "html", "xml", "json" },
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<M-space>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- {
	-- 	"folke/which-key.nvim",
	-- 	event = "VeryLazy",
	-- 	init = function()
	-- 		vim.o.timeout = true
	-- 		vim.o.timeoutlen = 300
	-- 	end,
	-- 	opts = {
	-- 		-- your configuration comes here
	-- 		-- or leave it empty to use the default settings
	-- 		-- refer to the configuration section below
	-- 	},
	-- },

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "dev-v3",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{ "williamboman/mason.nvim" }, -- Optional
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "L3MON4D3/LuaSnip" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
		},
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			popupmenu = {
				enabled = true,
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			-- "rcarriga/nvim-notify",
		},

		{
			"stevearc/conform.nvim",
			opts = {
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { { "prettierd", "prettier" } },
					html = { { "prettierd", "prettier" } },
					json = { { "prettierd", "prettier" } },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_fallback = true,
				},
			},
		},
	},
})

vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

local lsp = require("lsp-zero").preset({})

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr, preserve_mappings = false })
end)

-- lsp.set_sign_icons({
-- 	error = " ",
-- 	warn = " ",
-- 	hint = " ",
-- 	info = " ",
-- })

lsp.extend_cmp()

local cmp = require("cmp")
-- local lspkind = require("lspkind")
cmp.setup({
	preselect = cmp.PreselectMode.Item,
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "nvim_lsp_signature_help" },
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	}),
	-- formatting = {
	-- 	format = lspkind.cmp_format(),
	-- },
})

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "tsserver" },
	handlers = {
		lsp.default_setup,

		typst_lsp = function()
			require("lspconfig").typst_lsp.setup({
				settings = {
					exportPdf = "onSave", -- Choose onType, onSave or never.
					-- serverPath = "" -- Normally, there is no need to uncomment it.
				},
			})
		end,

		lua_ls = function()
			require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())
		end,
		tailwindcss = function()
			require("lspconfig").tailwindcss.setup({
				handlers = {
					["tailwindcss/getConfiguration"] = function(_, _, params, _, bufnr, _)
						vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id })
					end,
				},
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								{ "cx\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
							},
						},
						validate = true,
					},
				},
			})
		end,
	},
})

-- KEYMAPS
vim.keymap.set({ "n", "v" }, "<Space>", ":", { noremap = true })
vim.keymap.set("n", "U", "", { noremap = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "-", function()
	require("oil").open()
end, { desc = "Open parent directory" })

-- Move visual blocks up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", ":Format<CR>")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch [G]rep" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>d", builtin.diagnostics, { desc = "Search [d]iagnostics" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "List [b]uffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
