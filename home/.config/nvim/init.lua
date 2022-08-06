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
map("n", "", ":SK<CR>", options)
map("n", "", "", options)
map("c", "", "", options)
map("i", "", "", options)
map("n", "Y", "y$", options)
-- map("i", "<C-Space>", "", options)

-- Plugins installation
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({"git", "clone", "--depth=1", "https://github.com/wbthomason/packer.nvim", install_path})
end

require("packer").startup(
    function(use)
        use "wbthomason/packer.nvim"
        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
        use "jose-elias-alvarez/typescript.nvim"
        use "nvim-treesitter/nvim-treesitter-textobjects"
        use "nvim-lua/plenary.nvim"
        use "romainl/apprentice"
        use "luisiacc/gruvbox-baby"
        use "lewis6991/gitsigns.nvim"
        use {
            "marko-cerovac/material.nvim",
            config = function()
                require("material").setup({italics = {comments = true}})
            end
        }
        use "tpope/vim-fugitive"
        use "elihunter173/dirbuf.nvim"
        use "editorconfig/editorconfig-vim"
        use "echasnovski/mini.nvim"
        use "jose-elias-alvarez/null-ls.nvim"
        use "savq/melange"
        use {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end
        }
        use "neovim/nvim-lspconfig"
        use {
            "williamboman/mason-lspconfig.nvim",
            config = function()
                require("mason-lspconfig").setup()
            end
        }
    end
)

-- Colorscheme
-- vim.cmd("colorscheme apprentice")
-- vim.cmd("hi link NormalFloat Folded")
-- vim.cmd("hi Comment cterm=italic gui=italic")

-- Statusline
function my_statusline()
    local branch = vim.fn.FugitiveHead()

    if branch and #branch > 0 then
        branch = string.format("  %s ", branch)
    end

    return string.format("%s %%-.50F %%m%%= %%{&filetype}  %%l:%%c %%p%%%% ", branch)
end
vim.cmd("set statusline=%!luaeval('my_statusline()')")

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
require("mini.surround").setup({})
require("mini.completion").setup(
    {
        lsp_completion = {
            source_func = "omnifunc",
            auto_setup = false
        }
    }
)

-- LSP
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.keymap.set(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.MiniCompletion.completefunc_lsp")

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
    buf_set_keymap("n", "<Leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

require("typescript").setup(
    {
        server = {
            on_attach = function(client, bufnr)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>o", ":TypescriptOrganizeImports ", {noremap = true})
                client.resolved_capabilities.document_formatting = false
                on_attach(client, bufnr)
            end
        }
    }
)

require("lspconfig")["tailwindcss"].setup(
    {
        on_attach = on_attach
    }
)

require("lspconfig")["tailwindcss"].setup(
    {
        on_attach = on_attach
    }
)

require("lspconfig")["eslint"].setup(
    {
        on_attach = on_attach
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

require("gitsigns").setup()

vim.cmd("colo material")
