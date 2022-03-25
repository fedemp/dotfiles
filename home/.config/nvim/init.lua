-- Settings
local set = vim.opt

set.hidden = true
set.number = true
set.smartcase = true
set.cursorline = true
set.list = false
set.listchars = {eol = "↵", tab = "¬ ", trail = "·", extends = "◣", precedes = "◢", nbsp = "␣"}
set.foldmethod = "indent"
set.termguicolors = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 0
set.grepprg = "rg --vimgrep"
set.grepformat = "%f:%l:%c:%m"
set.inccommand = "split"
set.wildmode = "longest:full,full"
set.wildignore:append {"*/min/*", "*/vendor/*", "*/node_modules/*", "*/bower_components/*"}
set.diffopt = {"filler", "iwhiteall", "vertical", "hiddenoff", "algorithm:histogram"}
set.path = {".", "**"}
set.foldlevelstart = 99
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.completeopt = {"menuone"}
set.shortmess = "a"
set.colorcolumn = "120"
set.textwidth = 120
set.guicursor = "n-v-c-sm:block-nCursor,ve:block-blinkon500-iCursor,i-ci-r-cr-o:hor40-blinkon500"
set.signcolumn = "number"

-- Statusline
function my_statusline()
    local branch = vim.fn.FugitiveHead()

    if branch and #branch > 0 then
        branch = "  " .. branch .. " "
    end

    return branch .. " %-.50F %m%= %{&filetype}  %l:%c %p%% "
end
vim.cmd [[set statusline=%!luaeval('my_statusline()')]]

-- Colorscheme
vim.cmd [[colorscheme apprentice]]
vim.cmd [[hi link NormalFloat Folded]]
vim.cmd [[hi Comment cterm=italic gui=italic]]

-- Mappings
local map = vim.api.nvim_set_keymap
local options = {noremap = true, silent = true}

map("n", "<Space>", ":", {noremap = true})
map("n", "U", "", options)
map("n", "gb", ":ls<CR>:b ", {noremap = true})
map("n", "", ":SK<CR>", options)
map("n", "", "", options)
map("c", "", "", options)
map("i", "", "", options)
map("n", "Y", "y$", options)
map("i", "<C-Space>", "", options)


-- Plugins installation
local install_path = vim.fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({"git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", install_path})
end

require "paq" {
    "savq/paq-nvim",
    "neovim/nvim-lspconfig",
    "williamboman/nvim-lsp-installer",
    "machakann/vim-sandwich",
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "tpope/vim-commentary",
    "nvim-lua/plenary.nvim",
    "romainl/apprentice",
    "tpope/vim-fugitive",
    "NLKNguyen/papercolor-theme",
    "jsit/toast.vim",
    "habamax/vim-freyeday",
    "justinmk/vim-dirvish",
    "editorconfig/editorconfig-vim",
    "jose-elias-alvarez/null-ls.nvim",
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    "lifepillar/vim-gruvbox8",
    "sainnhe/sonokai"
}

-- Treesiter
require "nvim-treesitter.configs".setup {
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
                ["iC"] = "@comment.outer"
            }
        }
    },
    highlight = {
        enable = true,
        disable = {}
    },
    indent = {
        enable = true,
        disable = {}
    },
    ensure_installed = {
        "tsx",
        "json",
        "html",
        "scss",
        "json5"
    }
}
require "nvim-treesitter.parsers".get_parser_configs().tsx.filetype_to_parsername = {"javascript", "typescript.tsx"}

-- LSP
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = {noremap = true, silent = true}
	-- See `:help vim.lsp.*` for documentation on any of the below functions
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap("n", "<Leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<Leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<Leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

	-- Mappings.
	buf_set_keymap("n", "<Leader>o", ":TSLspOrganizeSync", {noremap = true})

	local ts_utils = require("nvim-lsp-ts-utils")
	ts_utils.setup {
		enable_import_on_completion = true
		-- filter_out_diagnostics_by_severity = {"hint"},
	}
	ts_utils.setup_client(client)
	-- disable tsserver formatting
	client.resolved_capabilities.document_formatting = false
end

local lsp_installer = require("nvim-lsp-installer")
-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(
    function(server)
        local opts = {}

		opts.debounce_text_changes = 150
		opts.on_attach = on_attach

        -- (optional) Customize the options passed to the server
        -- if server.name == "tsserver" or server.name == "tailwindcss" then

        -- This setup() function will take the provided server configuration and decorate it with the necessary properties
        -- before passing it onwards to lspconfig.
        -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        server:setup(opts)
    end
)

-- Formatting
local null_ls = require("null-ls")
null_ls.setup(
    {
        sources = {
            null_ls.builtins.formatting.prettier.with(
                {
                    only_local = "node_modules/.bin"
                }
            )
        }
    }
)
