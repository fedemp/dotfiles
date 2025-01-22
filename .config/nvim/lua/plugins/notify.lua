return {
	"echasnovski/mini.notify",
	version = "*",
	init = function()
		vim.notify = require("mini.notify").make_notify()
	end,
}
