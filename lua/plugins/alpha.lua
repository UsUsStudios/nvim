return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.startify")
		local original_header = {
			[[                                                          ]],
			[[                                                          ]],
			[[                                                          ]],
			[[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗      ]],
			[[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║      ]],
			[[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║      ]],
			[[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║      ]],
			[[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║      ]],
			[[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝      ]],
			[[                                                          ]],
			[[           UsUsStudios's Playground + Asylum              ]],
			[[                                                          ]],
		}
		local function center_lines(lines)
			local width = vim.api.nvim_get_option("columns")
			local max_len = 0
			for _, l in ipairs(lines) do
				local len = vim.fn.strdisplaywidth(l)
				if len > max_len then max_len = len end
			end
			local pad = math.max(0, math.floor((width - max_len) / 2))
			local padded = {}
			for _, l in ipairs(lines) do
				table.insert(padded, string.rep(" ", pad) .. l)
			end
			return padded
		end

		-- use the existing `original_header` variable (as defined earlier) and apply centering
		dashboard.section.header.val = center_lines(original_header)

		-- setup once
		alpha.setup(dashboard.opts)

		-- recenter on resize, grouped and scheduled to avoid timing issues
		local aug = vim.api.nvim_create_augroup("AlphaHeaderCenter", { clear = true })
		vim.api.nvim_create_autocmd("VimResized", {
			group = aug,
			callback = vim.schedule_wrap(function()
				dashboard.section.header.val = center_lines(original_header)
				alpha.redraw()
			end),
		})
		alpha.setup(dashboard.opts)
	end,
}