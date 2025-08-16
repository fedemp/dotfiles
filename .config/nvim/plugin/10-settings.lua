vim.opt.title = true -- Update window title.
vim.opt.colorcolumn = "+1" -- Visible column
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.inccommand = "split" -- Show global changes when doing search and replace
vim.opt.number = true -- Show line numbers
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.tabstop = 2 -- Tab width
vim.opt.smartcase = true -- Better ignorecase
vim.opt.infercase = true -- Better completion
vim.opt.textwidth = 79 -- Max text width for autowrapping
vim.opt.swapfile = false -- Turn off swapfile
vim.opt.scrolloff = 8 -- Always show 8 lines before cursor touches top or bottom
vim.opt.splitbelow = true -- Split new windows to the bottom
vim.opt.splitright = true -- Split new windows to the right
vim.opt.undofile = true -- Enable persistent undo
vim.opt.breakindent = true -- Indent wrapped lines to match line start
vim.opt.mouse = "" -- No mouse
vim.opt.wildignore:append({ "*/dist/*", "*/min/*", "*/vendor/*", "*/node_modules/*", "*/build/*" })
vim.opt.cursorlineopt = { "screenline", "number" } -- Highligth current screen line only
vim.opt.shortmess = "atToOCF" -- Kind of verbose
vim.opt.completeopt = { "menuone", "noselect" } -- Always show menu, don't autoselect
vim.opt.formatoptions = "qjl1" -- Don't autoformat comments
vim.opt.confirm = true -- Confirm unsaved
vim.opt.listchars = table.concat({ "extends:…", "nbsp:␣", "precedes:…", "tab:¬ " }, ",") -- Special text symbols
vim.diagnostic.config({
	float = { border = "double" },
	-- Show gutter sings
	signs = {
		-- With highest priority
		priority = 9999,
		-- Only for warnings and errors
		severity = { min = "WARN", max = "ERROR" },
	},
	-- Show virtual text only for errors
	virtual_text = { severity = { min = "ERROR", max = "ERROR" } },
	-- Don't update diagnostics when typing
	update_in_insert = false,
})

local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.o.foldmethod = "expr"
-- Default to treesitter folding
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end
	end,
})
