-- lua
return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local original_header = {
			[[                                                      ]],
			[[                                                      ]],
			[[                                                      ]],
			[[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ]],
			[[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ]],
			[[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ]],
			[[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ]],
			[[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ]],
			[[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ]],
			[[                                                      ]],
			[[          UsUsStudios's Playground + Asylum           ]],
			[[                                                      ]],
		}

		-- set header without manual padding; let alpha center it
		dashboard.section.header = dashboard.section.header or {}
		dashboard.section.header.val = original_header
		dashboard.section.header.opts = dashboard.section.header.opts or {}
		dashboard.section.header.opts.hl = "Title"
		dashboard.section.header.opts.position = "center"

		-- buttons (ensure group exists and is centered)
		dashboard.section.buttons = dashboard.section.buttons or {}
		dashboard.section.buttons.val = {
			dashboard.button("e", "  New file", "<cmd>ene<cr>"),
			dashboard.button("f", "󰈞  Find file", "<cmd>Telescope find_files<cr>"),
			dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
			dashboard.button("s", "  Settings", "<cmd>edit $MYVIMRC<cr>"),
			dashboard.button("l", "  Open Last Session", "<cmd>AutoSession restore<cr>"),
			dashboard.button("n", "󰢷  Open Neovim Config", "<cmd>:cd ~/.config/nvim/<cr>"),
			dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
		}
		dashboard.section.buttons.opts = dashboard.section.buttons.opts or {}
		dashboard.section.buttons.opts.hl = "Function"
		dashboard.section.buttons.opts.position = "center"

		local stats = require("lazy").stats()

		dashboard.section.footer.val = {
			"Plugins: " .. stats.count,
			"Startup: " .. string.format("%.2f ms", stats.startuptime),
		}

		-- vertical centering (defensive)
		local function compute_top_padding()
			local total_lines = vim.api.nvim_get_option("lines")
			local header_h = type(dashboard.section.header.val) == "table" and #dashboard.section.header.val or 0
			local buttons_h = (type(dashboard.section.buttons.val) == "table" and #dashboard.section.buttons.val or 0)
				* 2
			local footer_h = type(dashboard.section.footer.val) == "table" and #dashboard.section.footer.val or 0
			local used = header_h + buttons_h + footer_h
			return math.max(2, math.floor((total_lines - used) / 2))
		end

		dashboard.opts = dashboard.opts or {}
		dashboard.opts.layout = dashboard.opts.layout or {}
		if type(dashboard.opts.layout[1]) ~= "table" then
			dashboard.opts.layout[1] = { type = "padding", val = compute_top_padding() }
		else
			dashboard.opts.layout[1].val = compute_top_padding()
		end

		alpha.setup(dashboard.opts)

		local aug = vim.api.nvim_create_augroup("AlphaDashboard", { clear = true })
		vim.api.nvim_create_autocmd("VimResized", {
			group = aug,
			callback = vim.schedule_wrap(function()
				dashboard.section.header.val = original_header
				dashboard.section.footer.val = footer_text()
				if dashboard.opts and dashboard.opts.layout and dashboard.opts.layout[1] then
					dashboard.opts.layout[1].val = compute_top_padding()
				end
				alpha.redraw()
			end),
		})
	end,
}
