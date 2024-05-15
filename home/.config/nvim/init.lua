-- {{{ Settings
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
vim.opt.foldenable = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
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
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
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

		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
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
	require("mini.statusline").setup()
end)

now(function()
	add("nvim-tree/nvim-web-devicons")
	require("nvim-web-devicons").setup()
end)

-- {{{ LSP
now(function()
	add({
		source = "neovim/nvim-lspconfig",
		depends = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
	})

	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = { "tsserver", "lua_ls", "eslint-lsp" },
		handlers = {
			function(server_name)
				require("lspconfig")[server_name].setup({})
			end,

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
end)
later(function()
	require("mini.bufremove").setup()
end)
later(function()
	require("mini.comment").setup()
end)
later(function()
	require("mini.files").setup()
	vim.keymap.set({ "n" }, "-", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>", { noremap = true })
end)
later(function()
	require("mini.jump").setup()
end)
later(function()
	require("mini.pairs").setup()
end)
later(function()
	require("mini.completion").setup()
end)
later(function()
	require("mini.bracketed").setup()
end)
later(function()
	require("mini.pick").setup()
	vim.keymap.set({ "n" }, "<Leader><Leader>", "<cmd>Pick files<cr>", { noremap = true })
	vim.keymap.set({ "n" }, "<Leader>g", "<cmd>Pick grep<cr>", { noremap = true })
	vim.keymap.set({ "n" }, "gb", "<cmd>Pick buffers<cr>", { noremap = true })
end)
later(function()
	add("tpope/vim-fugitive")
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
now(function()
	require("mini.hues").setup({ background = "#dddddd", foreground = "#262626" })
	vim.cmd("colorscheme randomhue")
end)

later(function()
	add("nyoom-engineering/oxocarbon.nvim")
end)
later(function()
	add("Mofiqul/adwaita.nvim")
end)
later(function()
	add("shaunsingh/nord.nvim")
end)
later(function()
	add("e-q/okcolors.nvim")
end)
later(function()
	add("fynnfluegge/monet.nvim")
end)
later(function()
	add("projekt0n/github-nvim-theme")
end)
-- later(function() add({source: "mcchrish/zenbones.nvim", name = "zenbones", depends = { "rktjmp/lush.nvim" }}) end)
-- }}}
-- }}}

-- vim: foldmethod=marker foldlevel=1
