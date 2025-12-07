return {
	"navarasu/onedark.nvim",
	priority = 1000,
	config = function()
		require("onedark").setup({
			style = "darker",
			-- override palette entries used by the theme
			colors = {
				-- change the theme 'yellow' to a red hex
				yellow = "#0c6924",
			},
			-- you can also directly override highlight groups the theme defines
			highlights = {
				-- example: make identifiers and keywords use the new 'yellow'
				Identifier = { fg = "#0c6924" },
				Keyword = { fg = "#d1a206", bold = true },
			},
		})

		-- load the theme
		require("onedark").load()

		-- final / per-group overrides after the theme is loaded (optional)
		-- useful when a plugin defines groups after the theme setup
		vim.api.nvim_set_hl(0, "Function", { fg = "#ff4444" })
		vim.api.nvim_set_hl(0, "Type", { fg = "#1450b8" })
	end,
}
