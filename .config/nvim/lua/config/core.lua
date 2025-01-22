local opt = vim.opt

opt.title = true -- Update window title.
opt.colorcolumn = "80" -- Visible column
opt.cursorline = true -- Visible line
opt.inccommand = "split" -- Show global changes when doing search and replace
opt.number = true -- Show line numbers
opt.shiftwidth = 2 -- Indent width
opt.tabstop = 2 -- Tab width
opt.smartcase = true -- Better ignorecase
opt.textwidth = 79 -- Max text width for autowrapping
opt.swapfile = false -- Turn off swapfile
opt.scrolloff = 8 -- Always show 8 lines before cursor touches top or bottom
opt.splitbelow = true -- Split new windows to the bottom
opt.splitright = true -- Split new windows to the right
opt.undofile = true -- Enable persistent undo
opt.breakindent = true -- Indent wrapped lines to match line start
opt.ruler = false -- Don't show cursor position in command line
opt.showmode = false -- Don't show mode in command line
opt.completeopt   = 'menuone,noinsert,noselect' -- Customize completions
opt.formatoptions = 'qjl1' -- Don't autoformat comments

-- Unused opts. Reenable if needed.

-- vim.opt.signcolumn = "number"
-- vim.opt.backup = false
-- vim.opt.hlsearch = false
-- vim.opt.diffopt =
-- { "filler", "iwhiteall", "vertical", "hiddenoff", "closeoff", "hiddenoff", "algorithm:histogram", "linematch:60" }
-- vim.opt.listchars =
-- { eol = "↵", tab = "¬ ", lead = "·", trail = "·", extends = "◣", precedes = "◢", nbsp = "␣" }
-- vim.opt.list = false
-- vim.opt.wildignore:append({ "*/dist/*", "*/min/*", "*/vendor/*", "*/node_modules/*", "*/bower_components/*" })
-- vim.opt.completeopt = { "menu", "menuone", "noselect" }
