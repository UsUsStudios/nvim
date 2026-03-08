return {
	"manimvim",
	dir = "~/code/nvim/manimvim.nvim/",
	-- Explicitly tell Lazy this is local
	url = "~/code/nvim/manimvim.nvim/", -- Some versions need this
	-- Disable any git operations
	branch = nil,
	tag = nil,
	commit = nil,
	opts = {
		keymaps = {
			enable = true,
			render = "<leader>mm",
		},
		rendering = {
			quality = "m",
			play = true,
		},
	},
}
