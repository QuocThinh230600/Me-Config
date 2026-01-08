return {
	{
		"williamboman/mason.nvim",

		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",

		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			----------------------------------------------------------------
			-- clangd (C / C++) - Linux ARM (system clangd)
			----------------------------------------------------------------
			vim.lsp.config.clangd = {
				capabilities = capabilities,
				cmd = { "clangd", "--background-index" },
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_dir = vim.fs.root(0, {
					"compile_commands.json",
					"compile_flags.txt",
					".git",
				}),
			}
			vim.lsp.enable("clangd")

			----------------------------------------------------------------
			-- lua_ls
			----------------------------------------------------------------
			vim.lsp.config.lua_ls = {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}
			vim.lsp.enable("lua_ls")

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		end,
	},
}
