return {
	"echasnovski/mini.misc",
	version = "*",
	init = function()
		require("mini.misc").setup()
		MiniMisc.setup_termbg_sync()
	end,
}
