return {
	"vyfor/cord.nvim",
	build = ":Cord update",
	opts = {
		display = {
			theme = "minecraft",
			flavor = "accent",
		},
		editor = {
			tooltip = "My beloved Neovim",
		},
		text = {
			workspace = "Locking in on ${workspace}",
			editing = "Putting bugs in ${filename}",
		},
		variables = true,
	},
}
