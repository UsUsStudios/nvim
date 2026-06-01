return {
	"EdenEast/nightfox.nvim",
	config = function()
		Shade = require("nightfox.lib.shade")
		require("nightfox").setup({
			options = {
				transparent = true,
			},
			palettes = {
				all = {
					bg1 = "#0f1410",
					black = Shade.new("#000000", 0, 0),
					red = Shade.new("#de1010", 0.15, -0.15),
					green = Shade.new("#25be6a", 0.15, -0.15),
					yellow = Shade.new("#9ceb1e", 0.15, -0.15),
					blue = Shade.new("#009102", 0.15, -0.15),
					magenta = Shade.new("#78b9ff", 0.15, -0.15),
					cyan = Shade.new("#fffb00", 0.15, -0.15),
					white = Shade.new("#dfdfe0", 0.15, -0.15),
					orange = Shade.new("#ffbf00", 0.15, -0.15),
					pink = Shade.new("#FF7EB6", 0.15, -0.15),
				},
			},
		})
	end,
}
