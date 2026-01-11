vim.api.nvim_create_user_command("RustCheck", function()
	vim.cmd("!cargo check")
end, {})
