vim.g.mapleader = ' ' -- Use space as Leader

local map = vim.keymap.set

map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
map("n", "U", "", { noremap = true, silent = true, desc = "Redo" })

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "J", "mzJ`z")
map("v", "y", "mqy`q")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map({ "n", "v" }, "<leader>Y", '"+Y')
map({ "n", "v" }, "<leader>y", '"+y')
map({ "n", "v" }, "<leader>d", '"_d')
map({ "n", "v" }, "<leader>p", '"+p')
map({ "n", "v" }, "<leader>P", '"+P')
map({ "n", "v" }, "<leader>c", '"_c')

map("n", "<Tab>", "<cmd>bn<cr>")
map("n", "<s+Tab>", "<cmd>bp<cr>")
map("n", "<BS>", "")

map("n", "<Right>", "l")
map("n", "<Left>", "h")
map("n", "<Down>", "j")
map("n", "<Up>", "k")

map("n", "H", "^")
map("n", "L", "$")

map("t", "<esc><esc>", "<c-\\><c-n>")

map({"n", "v"}, "<Leader>w", "<cmd>w<CR>")
