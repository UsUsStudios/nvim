-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
local opts = { noremap = true, silent = true }

-- Run
vim.keymap.set("n", "<leader>r", function()
	local ft = vim.bo.filetype
	local file = vim.fn.expand("%")
	local file_noext = vim.fn.expand("%:r")
	local outfile = vim.fn.fnamemodify(file_noext, ":t")

	if ft == "c" then
		vim.cmd("!g++ " .. file .. " -o " .. outfile)
		vim.cmd("terminal ./" .. outfile)
	elseif ft == "cpp" then
		vim.cmd("!g++ " .. file .. " -o " .. outfile)
		vim.cmd("terminal ./" .. outfile)
	elseif ft == "java" then
		vim.cmd("terminal ./gradlew run run")
	elseif ft == "python" then
		vim.cmd("!python3 " .. file)
	elseif ft == "lua" then
		vim.cmd("!lua " .. file)
	elseif ft == "sh" then
		vim.cmd("!bash " .. file)
	else
		print("No compile command set for filetype: " .. ft)
	end
end, { noremap = true, silent = true })

-- Delete stuff without copying
vim.keymap.set("n", "x", '"_x', opts)
vim.keymap.set("n", "dd", '"_dd', opts)
vim.keymap.set("v", "d", '"_d', opts)

-- Make "xx" copy and delete a line
vim.keymap.set("n", "xx", "dd", opts)

-- Stay in visual mode after indenting
vim.keymap.set("v", ">", ">gv", opts)
vim.keymap.set("v", "<", "<gv", opts)

-- Centre find
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Esc -> ff
vim.keymap.set("i", "ff", "<Esc>", opts)
vim.keymap.set("v", "ff", "<Esc>", opts)
vim.keymap.set("c", "ff", "<Esc>", opts)
vim.keymap.set("t", "ff", "<Esc>", opts)

-- Redo
vim.keymap.set("n", "U", "<C-r>", opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>x", ":bdelete!<CR>", opts)
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts)

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- Split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- Split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- Make split windows equal width & height

-- Move between splits with arrow keys
vim.keymap.set("n", "<Up>", "<C-w>k", opts)
vim.keymap.set("n", "<Down>", "<C-w>j", opts)
vim.keymap.set("n", "<Left>", "<C-w>h", opts)
vim.keymap.set("n", "<Right>", "<C-w>l", opts)

-- Toggle Neo-tree with backslash
vim.keymap.set("n", "\\", ":Neotree toggle<CR>", opts)

-- Telescope Stuff
local builtin = require("telescope.builtin")

-- General Telescope pickers
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

-- LSP Symbols
vim.keymap.set("n", "<leader>sds", function()
	builtin.lsp_document_symbols({
		symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Property" },
	})
end, { desc = "[S]earch [D]ocument [S]ymbols" })

-- Grep only in open buffers
vim.keymap.set("n", "<leader>s/", function()
	builtin.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[S]earch [/] in Open Files" })

-- Fuzzy find in current buffer
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "[/] Fuzzy search in current buffer" })

-- LSP Keymaps
vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" })
vim.keymap.set("n", "gI", builtin.lsp_implementations, { desc = "[G]oto [I]mplementation" })
vim.keymap.set("n", "<leader>D", builtin.lsp_type_definitions, { desc = "Type [D]efinition" })
vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })
vim.keymap.set("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })

-- Workspace Management
vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "[W]orkspace [A]dd Folder" })
vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "[W]orkspace [R]emove Folder" })
vim.keymap.set("n", "<leader>wl", function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "[W]orkspace [L]ist Folders" })

-- Outline
vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", opts)
