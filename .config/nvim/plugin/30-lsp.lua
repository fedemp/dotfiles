local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
	add("williamboman/mason.nvim")
	require("mason").setup()
end)

now(function()
	add("neovim/nvim-lspconfig")

	local custom_on_attach = function(client, buf_id)
		-- Set up 'mini.completion' LSP part of completion
		vim.bo[buf_id].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
	end

	-- All language servers are expected to be installed with 'mason.vnim'
	local lspconfig = require("lspconfig")

	lspconfig.vtsls.setup({
		on_attach = custom_on_attach,
		settings = {
			vtsls = {
				experimental = {
					completion = {
						enableServerSideFuzzyMatch = true,
					},
				},
			},
		},
	})

	lspconfig.tailwindcss.setup({
		on_attach = custom_on_attach,
		settings = {
			tailwindCSS = {
				classAttributes = {
					"class",
					"className",
				},
				experimental = {
					classRegex = {
						{ "cx\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
						{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
						{ "cx\\(.*?\\)(?!\\])", "(?:'|\"|`)([^\"'`]*)(?:'|\"|`)" },
					},
				},
				validate = true,
			},
		},
	})

	lspconfig.lua_ls.setup({
		on_attach = custom_on_attach,
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					globals = { "vim" },
					disable = { "need-check-nil" },
					workspaceDelay = -1,
				},
				workspace = {
					-- Don't analyze code from submodules
					ignoreSubmodules = true,
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
			},
		},
	})

	lspconfig.biome.setup({})
end)
