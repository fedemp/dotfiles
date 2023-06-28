--------------
-- Settings --
--------------
vim.opt.colorcolumn = "80"
vim.opt.completeopt = { "menu", "menuone", "preview" }
vim.opt.cursorline = true
vim.opt.diffopt =
	{ "filler", "iwhiteall", "vertical", "hiddenoff", "closeoff", "hiddenoff", "algorithm:histogram", "linematch:60" }
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.foldmethod = "indent"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.hidden = true
vim.opt.inccommand = "split"
vim.opt.list = false
vim.opt.listchars =
	{ eol = "↵", tab = "¬ ", lead = "·", trail = "·", extends = "◣", precedes = "◢", nbsp = "␣" }
vim.opt.number = true
vim.opt.path = { ".", "**" }
vim.opt.shiftwidth = 0
vim.opt.shortmess = "at"
vim.opt.signcolumn = "number"
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.textwidth = 79
vim.opt.wildignore:append({ "*/min/*", "*/vendor/*", "*/node_modules/*", "*/bower_components/*" })
vim.opt.wildmode = "longest:full,full"
vim.opt.shell = "zsh"

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
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		-- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

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
			vim.lsp.buf.format({
				filter = function(client)
					-- apply whatever logic you want (in this example, we'll only use null-ls)
					return client.name == "null-ls"
				end,
			})
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
	"andymass/vim-matchup",

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			require("nvim-treesitter.configs").setup({
				matchup = {
					enable = true,
				},
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
							["<leader>s"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>S"] = "@parameter.inner",
						},
					},
				},
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<M-space>",
					},
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
			require("telescope").setup({})
			vim.keymap.set("n", "gb", require("telescope.builtin").buffers, { noremap = true, silent = true })
			vim.keymap.set("n", "<C-p>", require("telescope.builtin").fd, { noremap = true, silent = true })
			vim.keymap.set("n", "<Leader>d", ":Telescope diagnostics bufnr=0<cr>", { noremap = true, silent = true })
		end,
	},

	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = true,
	},
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",

	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"saadparwaiz1/cmp_luasnip",
	"L3MON4D3/LuaSnip",
	"hrsh7th/cmp-nvim-lsp-signature-help",

	{ "mcchrish/zenbones.nvim", dependencies = { "rktjmp/lush.nvim" } },
	"andreypopp/vim-colors-plain",
	"https://github.com/ramojus/mellifluous.nvim",
	"cideM/yui",
	"https://gitlab.com/maxice8/acme.nvim",
	"https://github.com/adigitoleo/vim-mellow",

	{ "stevearc/dressing.nvim", opts = {
		select = {
			backend = { "builtin" },
		},
	} },

	{
		"nvim-lualine/lualine.nvim",
		config = true,
		opts = {
			options = {
				icons_enabled = false,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
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
		"echasnovski/mini.nvim",
		config = function()
			require("mini.bracketed").setup({})
			require("mini.surround").setup({})
		end,
	},

	"tpope/vim-fugitive",

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
					null_ls.builtins.formatting.stylua,
				},
			})
		end,
	},

	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({
				skip_confirm_for_simple_edits = true,
			})
			vim.keymap.set("n", "-", function()
				require("oil").open()
			end, { desc = "Open parent directory" })
		end,
	},

	"https://github.com/amadeus/vim-mjml.git",
})

---------
-- LSP --
---------
-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = { "lua_ls", "eslint", "tsserver", "tailwindcss" },
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
		})
	end,
})

--------------
-- nvim-cmp --
--------------
local cmp = require("cmp")
local luasnip = require("luasnip")

luasnip.config.setup({})

-- nvim-cmp setup
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
		["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
		-- C-b (back) C-f (forward) for snippet placeholder navigation.
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = 'nvim_lsp_signature_help' }
	},
})

vim.cmd("colorscheme plain")

--------------
-- Commands --
--------------

vim.cmd("cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() =~# '^grep')  ? 'silent grep'  : 'grep'")
vim.cmd("cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() =~# '^lgrep') ? 'silent lgrep' : 'lgrep'")

----------
-- Term --
----------

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

---------------
-- Filetypes --
---------------
vim.filetype.add({
  extension = {
    eslintrc = "json",
    mdx = "markdown",
    prettierrc = "json",
    mjml = "html",
  },
  pattern = {
    [".*%.env.*"] = "sh",
  },
})
