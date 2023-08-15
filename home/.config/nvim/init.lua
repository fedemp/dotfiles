-- [[ Setting options ]]
vim.o.colorcolumn = '80'
vim.o.completeopt = 'menuone,noselect'
vim.o.cursorline = true
vim.o.grepformat = '%f:%l:%c:%m'
vim.o.grepprg = 'rg --vimgrep'
vim.o.inccommand = 'split'
vim.o.list = false
vim.o.number = true
vim.o.shell = 'zsh'
vim.o.shiftwidth = 4
vim.o.signcolumn = 'number'
vim.o.smartcase = true
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.textwidth = 79
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.updatetime = 250
vim.opt.diffopt = { 'filler', 'iwhiteall', 'vertical', 'hiddenoff', 'closeoff', 'hiddenoff', 'algorithm:histogram',
	'linematch:60' }
vim.opt.listchars = { eol = '↵', tab = '¬ ', lead = '·', trail = '·', extends = '◣', precedes = '◢', nbsp = '␣' }
vim.opt.wildignore:append { '*/dist/*', '*/min/*', '*/vendor/*', '*/node_modules/*', '*/bower_components/*' }

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	'tpope/vim-fugitive',
	'andymass/vim-matchup',

	{
		'echasnovski/mini.surround',
		event = 'VeryLazy',
		opts = {},
	},

	{
		'stevearc/oil.nvim',
		config = function()
			require('oil').setup {
				skip_confirm_for_simple_edits = true,
			}
			vim.keymap.set('n', '-', function()
				require('oil').open()
			end, { desc = 'Open parent directory' })
		end,
	},

	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'williamboman/mason.nvim', config = true },
			'williamboman/mason-lspconfig.nvim',

			{ 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

			'folke/neodev.nvim',
		},
	},

	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			require('luasnip.loaders.from_vscode').lazy_load()
			luasnip.config.setup {}

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete {},
					['<CR>'] = cmp.mapping.confirm { select = true },
					['<S-CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},
				sources = cmp.config.sources {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
					{ name = 'path' },
				},
				formatting = {
					format = function(_, item)
						local kinds = {
							Array = ' ',
							Boolean = ' ',
							Class = ' ',
							Color = ' ',
							Constant = ' ',
							Constructor = ' ',
							Copilot = ' ',
							Enum = ' ',
							EnumMember = ' ',
							Event = ' ',
							Field = ' ',
							File = ' ',
							Folder = ' ',
							Function = ' ',
							Interface = ' ',
							Key = ' ',
							Keyword = ' ',
							Method = ' ',
							Module = ' ',
							Namespace = ' ',
							Null = ' ',
							Number = ' ',
							Object = ' ',
							Operator = ' ',
							Package = ' ',
							Property = ' ',
							Reference = ' ',
							Snippet = ' ',
							String = ' ',
							Struct = ' ',
							Text = ' ',
							TypeParameter = ' ',
							Unit = ' ',
							Value = ' ',
							Variable = ' ',
						}
						if kinds[item.kind] then
							item.kind = kinds[item.kind] .. item.kind
						end
						return item
					end,
				},
			}
		end,
	},

	{ 'folke/which-key.nvim',    opts = {} },

	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
					{ buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
				vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
					{ buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
				vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
					{ buffer = bufnr, desc = '[P]review [H]unk' })
			end,
		},
	},

	{
		'gbprod/nord.nvim',
		priority = 1000,
		config = function()
			vim.cmd.colorscheme 'nord'
		end,
	},

	{
		'stevearc/dressing.nvim',
		opts = {
			select = {
				backend = { 'builtin' },
			},
		},
	},

	{ 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons', config = true },

	{
		'akinsho/toggleterm.nvim',
		opts = {
			open_mapping = [[<c-\>]],
			shade_terminals = false,
			terminal_mappings = true,
		},
	},

	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			theme = 'nord',
			options = {
				icons_enabled = true,
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
			},
			sections = {
				lualine_a = {
					{
						'mode',
						colors = { gui = 'bold' },
					},
				},
				lualine_b = { 'filename' },
				lualine_c = {},
				lualine_x = {
					'branch',
					{
						'diff',
						colored = true,                            -- Displays a colored diff status if set to true
						symbols = { added = ' ', modified = ' ', removed = ' ' }, -- Changes the symbols used by the diff.
					},
					{
						'diagnostics',
						symbols = {
							Error = ' ',
							Warn = ' ',
							Hint = ' ',
							Info = ' ',
						},
					},
				},
				lualine_y = { 'filetype' },
				lualine_z = { 'progress' },
			},
		},
	},

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		opts = {
			char = '┊',
			show_trailing_blankline_indent = false,
		},
	},

	-- "gc" to comment visual regions/lines
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup {
				pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
			}
		end,
		dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
	},

	-- Fuzzy Finder (files, lsp, etc)
	{ 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},

	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
			'JoosepAlviste/nvim-ts-context-commentstring',
		},
		opts = {
			-- Add languages to be installed here that you want installed for treesitter
			ensure_installed = { 'lua', 'tsx', 'typescript', 'vimdoc', 'vim', 'html', 'xml', 'json' },

			-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
			auto_install = false,

			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<c-space>',
					node_incremental = '<c-space>',
					scope_incremental = '<c-s>',
					node_decremental = '<M-space>',
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						['aa'] = '@parameter.outer',
						['ia'] = '@parameter.inner',
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['ac'] = '@class.outer',
						['ic'] = '@class.inner',
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						[']m'] = '@function.outer',
						[']]'] = '@class.outer',
					},
					goto_next_end = {
						[']M'] = '@function.outer',
						[']['] = '@class.outer',
					},
					goto_previous_start = {
						['[m'] = '@function.outer',
						['[['] = '@class.outer',
					},
					goto_previous_end = {
						['[M'] = '@function.outer',
						['[]'] = '@class.outer',
					},
				},
				swap = {
					enable = true,
					swap_next = {
						['<leader>a'] = '@parameter.inner',
					},
					swap_previous = {
						['<leader>A'] = '@parameter.inner',
					},
				},
			},
		},
		build = ':TSUpdate',
	},

	{
		"mhartington/formatter.nvim",
		config = function()
			require("formatter").setup {
				-- Enable or disable logging
				logging = true,
				-- Set the log level
				log_level = vim.log.levels.TRACE,
				filetype = {
					typescript = { require("formatter.filetypes.typescript").prettierd },
					typescriptreact = { require("formatter.filetypes.typescript").prettierd }
				}
			}
		end
	}
}, {})

-- [[ Basic Keymaps ]]
vim.keymap.set({ 'n', 'v' }, '<Space>', ':', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>x', ':bd<CR>', { noremap = true, desc = 'Delete current buffer' })
vim.keymap.set('n', 'U', '', { noremap = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'gb', require('telescope.builtin').buffers, { desc = '[ ] [G]o to [B]uffer' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
	},
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader><leader>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure LSP ]]

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		local bufnr = ev.buf

		local nmap = function(keys, func, desc)
			if desc then
				desc = 'LSP: ' .. desc
			end

			vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
		end

		nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
		nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
		nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
		nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
		nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
		nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
		nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
		nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
		nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
		nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
		nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
		nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
		nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
		nmap('<leader>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, '[W]orkspace [L]ist Folders')
	end,
})

local servers = {
	tsserver = {},
	tailwindcss = {},
	eslint = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require('neodev').setup()

local border = {
	{ "🭽", "FloatBorder" },
	{ "▔",  "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕",  "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁",  "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏",  "FloatBorder" },
}

-- LSP settings (for overriding per client)
local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			settings = servers[server_name],
			handlers = handlers
		}
	end,
}

vim.diagnostic.config {
	virtual_text = {
		prefix = '■', -- Could be '■', '▎', 'x'
	},
	severity_sort = true,
};

(function()
	local signs = {
		Error = ' ',
		Warn = ' ',
		Hint = ' ',
		Info = ' ',
	}
	for type, icon in pairs(signs) do
		local hl = 'DiagnosticSign' .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end
end)()


-- [[ Commands ]]
vim.cmd "cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() =~# '^grep')  ? 'silent grep'  : 'grep'"
vim.cmd "cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() =~# '^lgrep') ? 'silent lgrep' : 'lgrep'"

-- [[ Terminal ]]

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
	-- vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'

---------------
-- Filetypes --
---------------
vim.filetype.add {
	extension = {
		eslintrc = 'json',
		mdx = 'markdown',
		prettierrc = 'json',
		mjml = 'html',
	},
	pattern = {
		['.*%.env.*'] = 'sh',
	},
}
