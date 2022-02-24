-- Settings
local set = vim.opt

set.hidden = true;
set.number = true
set.smartcase = true;
set.cursorline = true;
set.list = false;
set.listchars = { eol="↵", tab = "¬ ", trail= "·",extends="◣",precedes="◢",nbsp="␣" }
set.foldmethod = "indent"
set.termguicolors = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 0
set.grepprg = "rg --vimgrep"
set.grepformat = "%f:%l:%c:%m"
set.inccommand = "split"
set.wildmode = "longest:full,full"
set.wildignore:append {"*/min/*","*/vendor/*","*/node_modules/*","*/bower_components/*"}
set.diffopt = {"filler", "iwhiteall", "vertical", "hiddenoff", "algorithm:histogram"}
set.path= {".","**"}
set.foldlevelstart = 99
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.completeopt = {"menuone"}
set.shortmess="a"
set.colorcolumn="120"
set.textwidth=120
set.guicursor="n-v-c-sm:block-nCursor,ve:block-blinkon500-iCursor,i-ci-r-cr-o:hor40-blinkon500"
set.signcolumn="number"

-- Mappings
local map = vim.api.nvim_set_keymap
local options = { noremap=true, silent=true }

map("n", "<Space>", ":", {noremap=true});
map("n", "U", "", options);
map("n", "gb", ":ls<CR>:b ", {noremap=true});
map("n", "", ":SK<CR>", options);
map("n", "", "", options);
map("c", "", "", options);
map("i", "", "", options);
map('n', 'Y', 'y$', options)
map('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', options)

-- Plugins
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

require "paq" {
	"savq/paq-nvim";
	"neovim/nvim-lspconfig";
    'williamboman/nvim-lsp-installer',
	"machakann/vim-sandwich";
	"nvim-treesitter/nvim-treesitter";
	"nvim-treesitter/nvim-treesitter-textobjects";
	"tpope/vim-commentary";
	'nvim-lua/plenary.nvim';
	'romainl/apprentice';
	'tpope/vim-fugitive';
	'NLKNguyen/papercolor-theme';
	'jsit/toast.vim';
	'wimstefan/vim-artesanal';
	'habamax/vim-freyeday';
	'jose-elias-alvarez/nvim-lsp-ts-utils';
	'justinmk/vim-dirvish';
	'editorconfig/editorconfig-vim';
	'jose-elias-alvarez/null-ls.nvim';
	'lifepillar/vim-gruvbox8'
}

vim.cmd [[colorscheme apprentice]]
vim.fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", numhl = "LspDiagnosticsDefaultHint"})

local fn, cmd = vim.fn, vim.cmd

function my_statusline()
  local branch = fn.FugitiveHead()

  if branch and #branch > 0 then
    branch = '  '..branch..' '
  end

  return branch..' %-.50F %m%= %{&filetype}  %l:%c %p%% '
end

cmd[[ set statusline=%!luaeval('my_statusline()') ]]

local nvim_lsp = require('lspconfig')
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap=true, silent=true }

	buf_set_keymap("i", "<C-Space>", "", opts);

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	-- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	-- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	-- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<Leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
	buf_set_keymap('n', '<Leader>o', ':TSLspOrganizeSync', {noremap=true})
	vim.cmd [[hi link LspReference  CursorLine]]
	vim.cmd [[hi link LspReferenceText CursorLine]]
	vim.cmd [[hi link LspReferenceWrite CursorLine]]
	vim.cmd [[hi link LspReferenceRead CursorLine]]
	vim.cmd [[hi link LspDiagnosticsDefaultError WarningMsg]]
	vim.cmd [[hi link LspDiagnosticsDefaultHint WarningMsg]]
	vim.cmd [[hi link LspDiagnosticsDefaultInformation WarningMsg]]
	vim.cmd [[hi link LspDiagnosticsDefaultWarning WarningMsg]]
	vim.cmd [[hi link LspDiagnosticsVirtualTextError Error]]
	vim.cmd [[hi link LspDiagnosticsVirtualTextWarning WarningMsg]]
	vim.cmd [[hi link LspDiagnosticsVirtualTextInformation WarningMsg]]
	vim.cmd [[hi link LspDiagnosticsVirtualTextHint WarningMsg]]
	vim.cmd [[hi LspDiagnosticsUnderlineError cterm=underline ctermfg=NONE gui=underline guifg=NONE term=underline]]
	vim.cmd [[hi LspDiagnosticsUnderlineWarning cterm=underline ctermfg=NONE gui=underline guifg=NONE term=underline]]
	vim.cmd [[hi LspDiagnosticsUnderlineInformation cterm=underline ctermfg=NONE gui=underline guifg=NONE term=underline]]
	vim.cmd [[hi LspDiagnosticsUnderlineHint cterm=underline ctermfg=NONE gui=underline guifg=NONE term=underline]]
	vim.cmd [[hi link NormalFloat Folded]]

	local ts_utils = require("nvim-lsp-ts-utils")
	ts_utils.setup {
		enable_import_on_completion = true,
		filter_out_diagnostics_by_severity = {"hint"},
	}
	ts_utils.setup_client(client);
	-- disable tsserver formatting
	client.resolved_capabilities.document_formatting = false
end

require'nvim-treesitter.configs'.setup {
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
		disable = {},
	},
	indent = {
		enable = true,
		disable = {},
	},
	ensure_installed = {
		"tsx",
		"json",
		"html",
		"scss",
		"json5",
	},
}
require "nvim-treesitter.parsers".get_parser_configs().tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

require'lspconfig'.tsserver.setup {
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
	}
}

require'lspconfig'.tailwindcss.setup{}

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
		null_ls.builtins.formatting.prettier.with({
			prefer_local = "node_modules/.bin",
		}),
		null_ls.builtins.diagnostics.eslint_d.with({
			prefer_local = "node_modules/.bin",
		}),
		null_ls.builtins.code_actions.eslint_d.with({
			prefer_local = "node_modules/.bin",
		}),
    },
})
