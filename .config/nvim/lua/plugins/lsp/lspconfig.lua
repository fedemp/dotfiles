return {
	"neovim/nvim-lspconfig",
	dependencies = { "saghen/blink.cmp" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				keymap.set("n", "K", vim.lsp.buf.hover, opts)
				keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				keymap.set("n", "gr", vim.lsp.buf.references, opts)
				keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
				keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
				keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", opts)
				keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
				keymap.set("n", "gl", vim.diagnostic.open_float)
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["graphql"] = function()
				-- configure graphql language server
				lspconfig["graphql"].setup({
					capabilities = capabilities,
					filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact" },
				})
			end,
			["lua_ls"] = function()
				require("lspconfig").lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
							},
							telemetry = {
								enable = false,
							},
						},
					},
				})
			end,
			["tailwindcss"] = function()
				require("lspconfig").tailwindcss.setup({
					capabilities = capabilities,
					handlers = {
						["tailwindcss/getConfiguration"] = function(_, _, params, _, bufnr, _)
							vim.lsp.buf_notify(bufnr, "tailwindcss/getConfigurationResponse", { _id = params._id })
						end,
					},
					settings = {
						tailwindCSS = {
							classAttributes = {
								"class",
								"className",
								"ngClass",
								".*ClassNames.*",
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
			end,
			["vtsls"] = function()
				require("lspconfig").vtsls.setup({
					capabilities = capabilities,
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
			end,
		})
	end,
}
