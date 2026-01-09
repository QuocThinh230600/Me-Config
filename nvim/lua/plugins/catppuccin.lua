return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
			term_colors = true,

			highlight_overrides = {
				all = function(colors)
					return {
						NeoTreeNormal = { bg = "NONE", fg = colors.text },
						NeoTreeNormalNC = { bg = "NONE", fg = colors.text },
						NeoTreeEndOfBuffer = { bg = "NONE", fg = colors.base },
						NeoTreeWinSeparator = { bg = "NONE", fg = colors.surface2 },

						CursorLine = { bg = "NONE" },
						CursorColumn = { bg = "NONE" },
						Visual = { bg = "NONE", style = { "reverse" } },
						Pmenu = { bg = "NONE" },
						PmenuSel = { bg = "NONE" },
					}
				end,
			},

			integrations = {
				treesitter = true,
				native_lsp = true,
				neotree = true, -- 👈 QUAN TRỌNG
			},
		})

		vim.cmd.colorscheme("catppuccin")

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "catppuccin",
			callback = function()
				vim.cmd([[
          highlight WinBar guibg=NONE ctermbg=NONE
          highlight WinBarNC guibg=NONE ctermbg=NONE
          highlight TabLine guibg=NONE ctermbg=NONE
          highlight TabLineFill guibg=NONE ctermbg=NONE
          highlight TabLineSel guibg=NONE ctermbg=NONE
        ]])
			end,
		})
	end,
}
