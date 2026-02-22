-- lua
return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local palette = require("nightfox.palette").load("nightfox")

		vim.api.nvim_set_hl(0, "AlphaHeaderTitle", { fg = palette.blue.base })
		vim.api.nvim_set_hl(0, "AlphaHeaderStats", { fg = palette.cyan.base })
		vim.api.nvim_set_hl(0, "AlphaHeaderValue", { fg = palette.orange.base })
		vim.api.nvim_set_hl(0, "AlphaHeaderDivid", { fg = palette.green.base })
		vim.api.nvim_set_hl(0, "AlphaButtons", { fg = palette.yellow.base })

		local original_header = {
			"                                                      ",
			"                                                      ",
			"                                                      ",
			"                                                      ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ",
			"                                                      ",
			"          UsUsStudios's Playground + Asylum           ",
			"                                                      ",
			"                                                      ",
		}

		local yaml = vim.fn.system({
			"onefetch",
			vim.fn.getcwd(),
			"--output",
			"yaml",
		})

		local onefetch_success = vim.v.shell_error == 0

		if onefetch_success then
			-- strip trailing newline
			yaml = yaml:gsub("%s+$", "")

			local parsed = vim.fn.system({
				"yq",
				[[
{
  "user": .title.gitUsername,
  "version": .title.gitVersion,
  "repo": .infoFields[0].ProjectInfo.repoName,
  "branches": .infoFields[0].ProjectInfo.numberOfBranches,
  "tags": .infoFields[0].ProjectInfo.numberOfTags,
  "head": .infoFields[2].HeadInfo.headRefs.shortCommitId,
  "added": .infoFields[3].PendingInfo.added,
  "deleted": .infoFields[3].PendingInfo.deleted,
  "created": .infoFields[5].CreatedInfo.creationDate,
  "lang": .infoFields[6].LanguagesInfo.languagesWithPercentage[0].language,
  "langpct": .infoFields[6].LanguagesInfo.languagesWithPercentage[0].percentage,
  "author": .infoFields[8].AuthorsInfo.authors[0].name,
  "commitsByAuthor": .infoFields[8].AuthorsInfo.authors[0].nbrOfCommits,
  "lastChange": .infoFields[9].LastChangeInfo.lastChange,
  "url": .infoFields[11].UrlInfo.repoUrl,
  "commits": .infoFields[12].CommitsInfo.numberOfCommits,
  "loc": .infoFields[14].LocInfo.linesOfCode,
  "size": .infoFields[15].SizeInfo.repoSize,
  "files": .infoFields[15].SizeInfo.fileCount,
}
  ]],
				"-",
			}, yaml)

			local data = vim.json.decode(parsed)

			local function build_onefetch_block()
				local lines = {}

				table.insert(lines, data.user .. " ~ " .. data.version)
				table.insert(lines, "-----------------------------")

				table.insert(
					lines,
					string.format("Project: %s (%s branches, %s tags)", data.repo, data.branches, data.tags)
				)

				table.insert(lines, "HEAD: " .. data.head)
				table.insert(lines, "Pending: " .. data.added .. "+ " .. data.deleted .. "-")
				table.insert(lines, "Created: " .. data.created)
				table.insert(lines, "Language: " .. data.lang .. " (" .. string.format("%.2f", data.langpct) .. "%)")
				table.insert(lines, "Top Author: " .. data.author .. " (" .. data.commitsByAuthor .. " commits)")
				table.insert(lines, "Last change: " .. data.lastChange)
				table.insert(lines, "Repo: " .. data.url)
				table.insert(lines, "Commits: " .. data.commits)
				table.insert(lines, "Lines of code: " .. data.loc)
				table.insert(lines, "Size: " .. data.size)
				table.insert(lines, "File Count: " .. data.files)

				return lines
			end

			local stat_lines = build_onefetch_block()

			local function merge_columns(left, right, gap)
				gap = gap or 4

				local width = 0
				for _, l in ipairs(left) do
					width = math.max(width, #l)
				end

				local height = math.max(#left, #right)
				local out = {}

				for i = 1, height do
					local l = left[i] or ""
					local r = right[i] or ""

					table.insert(out, l .. string.rep(" ", gap) .. r)
				end

				return out
			end

			dashboard.section.header.val = merge_columns(original_header, stat_lines, 7)
		else
			dashboard.section.header.val = original_header
		end
		-- set header without manual padding; let alpha center it
		dashboard.section.header.opts = dashboard.section.header.opts or {}
		dashboard.section.header.opts.hl = {
			{
				{ "AlphaHeaderTitle", 0, 61 },
				{ "AlphaHeaderStats", 61, 72 },
				{ "AlphaHeaderValue", 75, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 61 },
				{ "AlphaHeaderDivid", 61, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 61 },
				{ "AlphaHeaderStats", 61, 69 },
				{ "AlphaHeaderValue", 69, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 61 },
				{ "AlphaHeaderStats", 61, 66 },
				{ "AlphaHeaderValue", 66, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 137 },
				{ "AlphaHeaderStats", 137, 147 },
				{ "AlphaHeaderValue", 147, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 149 },
				{ "AlphaHeaderStats", 149, 158 },
				{ "AlphaHeaderValue", 158, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 137 },
				{ "AlphaHeaderStats", 137, 152 },
				{ "AlphaHeaderValue", 152, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 145 },
				{ "AlphaHeaderStats", 145, 160 },
				{ "AlphaHeaderValue", 160, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 145 },
				{ "AlphaHeaderStats", 145, 163 },
				{ "AlphaHeaderValue", 163, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 135 },
				{ "AlphaHeaderStats", 135, 140 },
				{ "AlphaHeaderValue", 140, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 61 },
				{ "AlphaHeaderStats", 61, 69 },
				{ "AlphaHeaderValue", 69, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 61 },
				{ "AlphaHeaderStats", 61, 75 },
				{ "AlphaHeaderValue", 75, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 61 },
				{ "AlphaHeaderStats", 61, 66 },
				{ "AlphaHeaderValue", 66, 200 },
			},
			{
				{ "AlphaHeaderTitle", 0, 61 },
				{ "AlphaHeaderStats", 61, 72 },
				{ "AlphaHeaderValue", 72, 200 },
			},
		}

		dashboard.section.header.opts.position = "center"

		-- buttons (ensure group exists and is centered)
		dashboard.section.buttons = dashboard.section.buttons or {}
		dashboard.section.buttons.val = {
			dashboard.button("e", "  New file", "<cmd>ene<cr>"),
			dashboard.button("f", "󰈞  Find file", "<cmd>Telescope find_files<cr>"),
			dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<cr>"),
			dashboard.button("s", "  Settings", "<cmd>edit $MYVIMRC<cr>"),
			dashboard.button("l", "  Open Last Session", "<cmd>AutoSession restore<cr>"),
			dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
		}
		dashboard.section.buttons.opts = dashboard.section.buttons.opts or {}
		dashboard.section.buttons.opts.position = "center"

		local stats = require("lazy").stats()

		dashboard.section.footer.opts = { position = "center", hl = "Type" }
		dashboard.section.footer.val = {
			"Plugins: " .. stats.count,
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
	end,
}
