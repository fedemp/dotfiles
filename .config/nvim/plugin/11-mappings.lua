vim.g.mapleader = " " -- Use space as Leader

local map = vim.keymap.set

map({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, desc = "j iterates screen lines" })
map({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, desc = "k iterates screen lines" })

map("n", "U", "", { noremap = true, silent = true, desc = "Redo" }) -- u undoes, U redoes

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move block of text in visual mode downwards" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move block of text in visual mode upwards" })

map("n", "J", "mzJ`z", { desc = "Restore position after joining lines" })
map("v", "y", "mqy`q", { desc = "Restore position after yanking" })

map("n", "<C-d>", "<C-d>zz", { desc = "Center cursor line after jumping" })
map("n", "<C-u>", "<C-u>zz", { desc = "Center cursor line after jumping" })

map("n", "n", "nzzzv", { desc = "Open fold after search jump" })
map("n", "N", "Nzzzv", { desc = "Open fold after search jump" })

map({ "n", "v" }, "<leader>Y", '"+Y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>c", '"_c', { desc = "Change with overwriting" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete with overwriting" })

map("n", "<Tab>", "<cmd>bn<cr>", { desc = "Go to next buffer" })
map("n", "<s+Tab>", "<cmd>bp<cr>", { desc = "Go to previous buffer" })
map("n", "<BS>", "", { desc = "Go to alternate buffer" })

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Window resize (respecting `v:count`)
map(
	"n",
	"<C-Left>",
	'"<Cmd>vertical resize -" . v:count1 . "<CR>"',
	{ expr = true, replace_keycodes = false, desc = "Decrease window width" }
)
map(
	"n",
	"<C-Down>",
	'"<Cmd>resize -" . v:count1 . "<CR>"',
	{ expr = true, replace_keycodes = false, desc = "Decrease window height" }
)
map(
	"n",
	"<C-Up>",
	'"<Cmd>resize +" . v:count1 . "<CR>"',
	{ expr = true, replace_keycodes = false, desc = "Increase window height" }
)
map(
	"n",
	"<C-Right>",
	'"<Cmd>vertical resize +" . v:count1 . "<CR>"',
	{ expr = true, replace_keycodes = false, desc = "Increase window width" }
)

map("n", "H", "^", { desc = "Move to first non white char" })
map("n", "L", "$", { desc = "Move to last non white char" })

map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Easy normal mode in terminal" })

map("n", "<Leader>l", function()
	local win = vim.api.nvim_get_current_win()
	local qf_winid = vim.fn.getloclist(win, { winid = 0 }).winid
	local action = qf_winid > 0 and "lclose" or "lopen"
	vim.cmd(action)
end, { noremap = true, silent = true })

map("n", "<Leader>q", function()
	local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
	local action = qf_winid > 0 and "cclose" or "copen"
	vim.cmd("botright " .. action)
end, { noremap = true, silent = true })

-- Mappings that require plugins
map("n", "<Leader>bd", "<cmd>lua MiniBufremove.delete()<CR>", { desc = "Delete buffer" })
map("n", "-", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>", { desc = "File directory" })

map("n", "<Leader><Leader>", "<cmd>Pick files<cr>", { desc = "Files" })
map("n", "<Leader>g", "<cmd>Pick grep_live<cr>", { desc = "Grep live" })
map("n", "<Leader>b", "<cmd>Pick buffers<cr>", { desc = "Buffers" })
