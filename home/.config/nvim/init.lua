-- Settings
local set = vim.opt

set.colorcolumn = "80"
set.completeopt = { "menu", "menuone", "preview" }
set.cursorline = true
set.diffopt =
	{ "filler", "iwhiteall", "vertical", "hiddenoff", "closeoff", "hiddenoff", "algorithm:histogram", "linematch:60" }
set.foldexpr = "nvim_treesitter#foldexpr()"
set.foldlevelstart = 99
set.foldmethod = "expr"
set.foldmethod = "indent"
set.grepformat = "%f:%l:%c:%m"
set.grepprg = "rg --vimgrep"
set.hidden = true
set.inccommand = "split"
set.list = false
set.listchars = { eol = "↵", tab = "¬ ", lead = "·", trail = "·", extends = "◣", precedes = "◢", nbsp = "␣" }
set.number = true
set.path = { ".", "**" }
set.shiftwidth = 0
set.shortmess = "at"
set.signcolumn = "number"
set.smartcase = true
set.softtabstop = 4
set.tabstop = 4
set.termguicolors = true
set.textwidth = 79
set.wildignore:append({ "*/min/*", "*/vendor/*", "*/node_modules/*", "*/bower_components/*" })
set.wildmode = "longest:full,full"

vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- Could be '■', '▎', 'x'
	},
	severity_sort = true,
});

(function()
	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end
end)()

vim.keymap.set("i", "<C-Space>", "", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>", ":", { noremap = true })
vim.keymap.set("n", "U", "", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>e", "vim.diagnostic.open_float", { noremap = true, silent = true })
vim.keymap.set("n", "[d", "vim.diagnostic.goto_prev", { noremap = true, silent = true })
vim.keymap.set("n", "]d", "vim.diagnostic.goto_next", { noremap = true, silent = true })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<Leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<Leader>a", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<Leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

-- Plugins
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

if os.getenv("NVIM") ~= nil then
	require("lazy").setup({
		{ "willothy/flatten.nvim", config = true },
	})
	return
end

require("lazy").setup({
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aC"] = "@comment.outer",
							["iC"] = "@comment.outer",
						},
					},
				},
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				ensure_installed = {
					"javascript",
					"typescript",
					"css",
					"vim",
					"tsx",
					"json",
					"html",
					"scss",
					"json5",
				},
			})
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { { "nvim-lua/plenary.nvim" } },
		config = function()
			require("telescope").setup();
			vim.keymap.set("n", "gb", require("telescope.builtin").buffers, { noremap = true, silent = true })
			vim.keymap.set("n", "<C-p>", require("telescope.builtin").fd, { noremap = true, silent = true })
		end
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.tsserver.setup({})
			lspconfig.tailwindcss.setup({})
			lspconfig.eslint.setup({})
		end,
	},

	{
		"williamboman/mason.nvim",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = true,
	},

	{ "mcchrish/zenbones.nvim", dependencies = { "rktjmp/lush.nvim" } },

	"stevearc/dressing.nvim",
	--{
	--	"hood/popui.nvim",
	--	config = function()
	--		vim.ui.select = require("popui.ui-overrider")
	--		vim.ui.input = require("popui.input-overrider")
	--		vim.api.nvim_set_keymap(
	--			"n",
	--			",d",
	--			':lua require"popui.diagnostics-navigator"()<CR>',
	--			{ noremap = true, silent = true }
	--		)
	--		vim.api.nvim_set_keymap(
	--			"n",
	--			",m",
	--			':lua require"popui.marks-manager"()<CR>',
	--			{ noremap = true, silent = true }
	--		)
	--		vim.api.nvim_set_keymap(
	--			"n",
	--			",r",
	--			':lua require"popui.references-navigator"()<CR>',
	--			{ noremap = true, silent = true }
	--		)
	--	end,
	--},

	-- "tpope/vim-fugitive",

	"nvim-lualine/lualine.nvim",

	{ "akinsho/toggleterm.nvim", opts = {
		open_mapping = [[<c-\>]],
		shade_terminals = false,
	} },

	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.bracketed").setup()
			require("mini.completion").setup()
			require("mini.pairs").setup()
		end,
	},

	{
		"willothy/flatten.nvim",
		config = true,
		opts = {
			window = {
				open = "alternate",
			},
			callbacks = {
				should_block = function(argv)
					-- Note that argv contains all the parts of the CLI command, including
					-- Neovim's path, commands, options and files.
					-- See: :help v:argv

					-- In this case, we would block if we find the `-b` flag
					-- This allows you to use `nvim -b file1` instead of `nvim --cmd 'let g:flatten_wait=1' file1`
					return vim.tbl_contains(argv, "-b")

					-- Alternatively, we can block if we find the diff-mode option
					-- return vim.tbl_contains(argv, "-d")
				end,
				post_open = function(bufnr, winnr, ft, is_blocking)
					if is_blocking then
						-- Hide the terminal while it's blocking
						require("toggleterm").toggle(0)
					else
						-- If it's a normal file, just switch to its window
						vim.api.nvim_set_current_win(winnr)
					end

					-- If the file is a git commit, create one-shot autocmd to delete its buffer on write
					-- If you just want the toggleable terminal integration, ignore this bit
					if ft == "gitcommit" then
						vim.api.nvim_create_autocmd("BufWritePost", {
							buffer = bufnr,
							once = true,
							callback = function()
								-- This is a bit of a hack, but if you run bufdelete immediately
								-- the shell can occasionally freeze
								vim.defer_fn(function()
									vim.api.nvim_buf_delete(bufnr, {})
								end, 50)
							end,
						})
					end
				end,
				block_end = function()
					-- After blocking ends (for a git commit, etc), reopen the terminal
					require("toggleterm").toggle(0)
				end,
			},
		},
		lazy = false,
		priority = 1001,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettierd,
				},
			})
		end,
	},

	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
			vim.keymap.set("n", "-", function()
				require("oil").open()
			end, { desc = "Open parent directory" })
		end,
	},
})
