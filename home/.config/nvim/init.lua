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
set.completeopt = {"menu", "menuone", "noselect"}
set.shortmess = "at"
set.colorcolumn = "80"
set.textwidth = 79
set.signcolumn = "number"

-- Mappings
local map = vim.keymap.set
local options = {noremap = true, silent = true}

map("n", "<Space>", ":", {noremap = true})
map("n", "U", "", options)
map("n", "gb", ":ls<CR>:b ", {noremap = true})
map("n", "", ":FZF<CR>", options)
map("n", "", "", options)
map("c", "", "", options)
map("i", "", "", options)
map("n", "Y", "y$", options)
map("i", "<C-Space>", "", options)

-- Plugins installation
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({"git", "clone", "--depth=1", "https://github.com/wbthomason/packer.nvim", install_path})
end

require("packer").startup(
    function(use)
        use "wbthomason/packer.nvim"
        use "nvim-lua/plenary.nvim"
        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
        use "nvim-treesitter/nvim-treesitter-textobjects"
        use "neovim/nvim-lspconfig"
        use "jose-elias-alvarez/typescript.nvim"
        use "jose-elias-alvarez/null-ls.nvim"
        -- use "savq/melange"
        use {"mcchrish/zenbones.nvim", requires = {"rktjmp/lush.nvim"}}
        -- use {
        --     "EdenEast/nightfox.nvim",
        --     config = function()
        --         require("nightfox").setup(
        --             {
        --                 options = {
        --                     styles = {
        --                         comments = "italic",
        --                         keywords = "bold",
        --                         types = "italic,bold"
        --                     }
        --                 }
        --             }
        --         )
        --     end
        -- }
        use {'hood/popui.nvim',
        	config = function()
        		vim.ui.select = require"popui.ui-overrider"
        		vim.ui.input = require"popui.input-overrider"
        	end
        }
        use "tpope/vim-fugitive"
        use {
            "lewis6991/gitsigns.nvim",
            config = function()
                require("gitsigns").setup()
            end
        }
        use "elihunter173/dirbuf.nvim"
        use "editorconfig/editorconfig-vim"
        use "echasnovski/mini.nvim"
        use "samjwill/nvim-unception"
        use "akinsho/toggleterm.nvim"
        use {
            "nvim-lualine/lualine.nvim",
            config = function()
                require("lualine").setup(
                    {
                        icons_enabled = true
                    }
                )
            end,
            requires = {"kyazdani42/nvim-web-devicons"}
        }
        use "kyazdani42/nvim-web-devicons"
        -- use {"doums/suit.nvim",
        -- 	config = function()
        -- 		require("suit").setup()
        -- 	end
        -- }
        use {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end
        }
        use {
            "williamboman/mason-lspconfig.nvim",
            config = function()
                require("mason-lspconfig").setup()
            end
        }
        use "hrsh7th/cmp-nvim-lsp"
        use "hrsh7th/cmp-buffer"
        use "hrsh7th/cmp-path"
        use "hrsh7th/nvim-cmp"
        use "hrsh7th/cmp-vsnip"
        use "hrsh7th/vim-vsnip"
		use {
			'nvim-telescope/telescope.nvim', tag = '0.1.0',
			-- or                            , branch = '0.1.x',
			requires = { {'nvim-lua/plenary.nvim'} }
		}
	end
	)

-- Colorscheme
vim.cmd("colorscheme nordbones")
-- vim.cmd("hi link NormalFloat Folded")
-- vim.cmd("hi Comment cterm=italic gui=italic")

-- Statusline
-- function my_statusline()
-- 	local branch = vim.fn.FugitiveHead()
--
-- 	if branch and #branch > 0 then
-- 		branch = string.format("  %s ", branch)
-- 	end
--
-- 	return string.format("%s %%-.50F %%m%%= %%{&filetype}  %%l:%%c %%p%%%% ", branch)
-- end
-- vim.cmd("set statusline=%!luaeval('my_statusline()')")

-- Treesiter
require("nvim-treesitter.configs").setup {
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
        enable = true
    },
    indent = {
        enable = true
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
        "json5"
    }
}

-- Mini
require("mini.surround").setup()
require("mini.comment").setup()
require("mini.bufremove").setup({})
-- require('mini.statusline').setup({})

local cmp = require "cmp"

cmp.setup(
    {
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            end
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered()
        },
        mapping = cmp.mapping.preset.insert(
            {
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }
        ),
        sources = cmp.config.sources(
            {
                {name = "nvim_lsp"}
                -- { name = 'vsnip' }, -- For vsnip users.
                -- { name = 'luasnip' }, -- For luasnip users.
                -- { name = 'ultisnips' }, -- For ultisnips users.
                -- { name = 'snippy' }, -- For snippy users.
            },
            {
                {name = "buffer"}
            }
        )
    }
)

-- LSP
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.keymap.set(...)
    end

    -- local lsp_formatting = function(bufnr)
    -- 	vim.lsp.buf.format({
    -- 		filter = function(client)
    -- 			-- apply whatever logic you want (in this example, we'll only use null-ls)
    -- 			return client.name == "null-ls"
    -- 		end,
    -- 		bufnr = bufnr,
    -- 	})
    -- end

    -- Mappings.
    local opts = {noremap = true, silent = true, buffer = bufnr}
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
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
    -- buf_set_keymap("n", "<Leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    buf_set_keymap("n", "<Leader>q", "<cmd>lua require'popui.diagnostics-navigator'()<CR>", opts)
    buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
    buf_set_keymap("n", "<Leader>d", "<cmd>lua require'popui.diagnostics-navigator'()<CR>", opts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("typescript").setup(
    {
        server = {
            on_attach = function(client, bufnr)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>o", ":TypescriptOrganizeImports ", {noremap = true})
                on_attach(client, bufnr)
            end,
            capabilities = capabilities
        }
    }
)

require("lspconfig")["tailwindcss"].setup(
    {
        on_attach = on_attach,
        capabilities = capabilities
    }
)

require("lspconfig")["eslint"].setup(
    {
        on_attach = on_attach,
        capabilities = capabilities
    }
)

local null_ls = require("null-ls")
null_ls.setup(
    {
        sources = {
            null_ls.builtins.formatting.prettierd
        }
    }
)

-- Terminal settings
vim.api.nvim_create_autocmd({"TermOpen"}, {pattern = {"*"}, command = "setlocal nonumber norelativenumber"})

local M = {}

M.icons = {
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Enum = "𝍣  ",
    EnumMember = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "𝐅 ",
    Interface = "⍗ ",
    Keyword = " ",
    Method = "ƒ ",
    Module = " ",
    Property = " ",
    Snippet = "﬌ ",
    Struct = " ",
    Text = " ",
    Unit = " ",
    Value = " ",
    Variable = " "
}

function M.setup()
    local kinds = vim.lsp.protocol.CompletionItemKind
    for i, kind in ipairs(kinds) do
        kinds[i] = M.icons[kind] or kind
    end
end

M.setup()

local signs = {Error = " ", Warn = " ", Hint = " ", Info = " "}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

vim.diagnostic.config(
    {
        virtual_text = {
            prefix = "●" -- Could be '■', '▎', 'x'
        }
    }
)

vim.g.unception_enable_flavor_text = false
vim.g.unception_open_buffer_in_new_tab = true

require("toggleterm").setup {
    open_mapping = [[<c-\>]],
    shade_terminals = false
}

vim.ui.select = require "popui.ui-overrider"
vim.ui.input = require "popui.input-overrider"
