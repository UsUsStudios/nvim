require("config.options")
require("config.lazy")
require("config.keymaps")

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
	-- Save to a fixed file
		vim.cmd("mksession! ~/.local/state/nvim/session.vim")
	end,
})

vim.lsp.enable("lspconfig")