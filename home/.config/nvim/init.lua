-- {{{ Settings
vim.opt.title = true
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
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.scrolloff = 999
vim.opt.splitbelow = true
vim.opt.splitright = true

-- }}}
-- {{{ Mappings
vim.keymap.set({ "n", "v" }, "<Space>", ":", { noremap = true })
vim.keymap.set("n", "U", "", { noremap = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P')
vim.keymap.set({ "n", "v" }, "<leader>c", '"_c"', { noremap = true, silent = true })
vim.keymap.set("n", "gl", vim.diagnostic.open_float)
vim.keymap.set("v", "y", "mqy`q")
vim.keymap.set("n", "<Tab>", "<cmd>bn<cr>")
vim.keymap.set("n", "<s+Tab>", "<cmd>bp<cr>")
vim.keymap.set("n", "<Right>", "l")
vim.keymap.set("n", "<Left>", "h")
vim.keymap.set("n", "<Down>", "j")
vim.keymap.set("n", "<Up>", "k")
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("n", "<BS>", "")
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
-- Handled by mini.bracketed
-- vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>") --
-- vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

--- {{{ LSP Mappings
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		-- these will be buffer-local keybindings
		-- because they only work if you have an active language server

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
		vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
		vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
		vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	end,
})
-- }}}
-- }}}

-- {{{ Dependencies
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	require("mini.git").setup()
	require("mini.statusline").setup()
	require("mini.icons").setup()
end)

-- {{{ LSP
now(function()
	add({
		source = "neovim/nvim-lspconfig",
		depends = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
	})

	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = { "lua_ls", "eslint" },
		handlers = {
			function(server_name)
				require("lspconfig")[server_name].setup({})
			end,

			lua_ls = function()
				require("lspconfig").lua_ls.setup({
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
							},
							telemetry = {
								enable = false,
							},
						},
					},
				})
			end,

			-- tsserver = function()
			-- 	require("lspconfig").tsserver.setup({
			-- 		settings = {
			-- 			completions = {
			-- 				completeFunctionCalls = true,
			-- 			},
			-- 		},
			-- 		init_options = {
			-- 			preferences = {
			-- 				includeCompletionsWithSnippetText = true,
			-- 				includeCompletionsForImportStatements = true,
			-- 			},
			-- 		},
			-- 	})
			-- end,

			typst_lsp = function()
				require("lspconfig").typst_lsp.setup({
					settings = {
						exportPdf = "onSave", -- Choose onType, onSave or never.
						-- serverPath = "" -- Normally, there is no need to uncomment it.
					},
				})
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
end)
-- }}}

later(function()
	require("mini.surround").setup()
	require("mini.bufremove").setup()
	require("mini.comment").setup()
	-- require("mini.jump").setup()
	require("mini.completion").setup()
	require("mini.bracketed").setup()
end)
later(function()
	require("mini.files").setup()
	vim.keymap.set({ "n" }, "-", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>", { noremap = true })
end)
later(function()
	local choose_all = function()
		local mappings = MiniPick.get_picker_opts().mappings
		vim.api.nvim_input(mappings.mark_all .. mappings.choose_marked)
	end
	require("mini.pick").setup({
		mappings = {
			choose_all = { char = "<C-q>", func = choose_all },
		},
	})
	vim.keymap.set({ "n" }, "<Leader><Leader>", "<cmd>Pick files<cr>", { noremap = true })
	vim.keymap.set({ "n" }, "<Leader>g", "<cmd>Pick grep<cr>", { noremap = true })
	vim.keymap.set({ "n" }, "gb", "<cmd>Pick buffers<cr>", { noremap = true })
end)

later(function()
	add("tpope/vim-fugitive")
	add({ source = "NeogitOrg/neogit", depends = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" } })
	require("neogit").setup()
end)

later(function()
	add({ source = "stevearc/dressing.nvim", depends = { "MunifTanjim/nui.nvim" } })
	require("dressing").setup({
		select = {
			backend = { "nui" },
		},
	})
end)

later(function()
	add({
		source = "akinsho/toggleterm.nvim",
	})
	require("toggleterm").setup({
		open_mapping = [[<c-\>]],
		shade_terminals = false,
		terminal_mappings = true,
	})
end)

later(function()
	add({ source = "kevinhwang91/nvim-ufo", depends = { "kevinhwang91/promise-async" } })

	vim.o.foldcolumn = "1" -- '0' is not bad
	vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true

	-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
	vim.keymap.set("n", "zR", require("ufo").openAllFolds)
	vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

	require("ufo").setup({
		provider_selector = function()
			return { "treesitter", "indent" }
		end,
	})
end)

-- {{{ Treesitter
later(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "master",
		monitor = "main",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	require("nvim-treesitter.configs").setup({
		ensure_installed = { "lua", "tsx", "javascript", "typescript", "vimdoc", "vim", "html", "xml", "json" },
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<Enter>",
				node_incremental = "<Enter>",
				node_decremental = "<BS>",
				scope_incremental = "<c-s>",
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
end)
-- }}}

-- {{{ Conform
later(function()
	add("stevearc/conform.nvim")
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { { "prettierd", "prettier" } },
			typescript = { { "prettierd", "prettier" } },
			typescriptreact = { { "prettierd", "prettier" } },
			html = { { "prettierd", "prettier" } },
			json = { { "prettierd", "prettier" } },
			graphql = { { "prettierd", "prettier" } },
			scss = { { "prettierd", "prettier" } },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_fallback = true,
		},
	})
	vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
end)
-- }}}

-- {{{ Colorschemes

later(function()
	add("projekt0n/github-nvim-theme")
	add("nyoom-engineering/oxocarbon.nvim")
	add("shaunsingh/nord.nvim")
	add("e-q/okcolors.nvim") -- No support for mini.pick
	add({ source = "mcchrish/zenbones.nvim", name = "zenbones", depends = { "rktjmp/lush.nvim" } })
	add("sainnhe/gruvbox-material")
end)

--- }}}

--- {{{ Terminal
vim.api.nvim_create_autocmd("TermOpen", {
	command = [[setlocal nonumber norelativenumber]],
})
--- }}}

-- vim: foldmethod=marker foldlevel=1
