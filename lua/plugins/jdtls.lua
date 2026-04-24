return {
	"mfussenegger/nvim-jdtls",
	ft = "java", -- only loads for java files
	config = function()
		local jdtls = require("jdtls")
		local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

		-- Unique workspace dir per project
		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

		local config = {
			cmd = {
				"java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xmx1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
				"-configuration",
				mason_path .. "/config_linux", -- change to config_mac or config_win if needed
				"-data",
				workspace_dir,
			},

			root_dir = require("jdtls.setup").find_root({ "build.gradle", "settings.gradle", ".git" }),

			settings = {
				java = {
					import = {
						gradle = { enabled = true },
						maven = { enabled = true },
					},
					eclipse = { downloadSources = true },
					maven = { downloadSources = true },
				},
			},
		}

		-- Start or attach jdtls
		jdtls.start_or_attach(config)
	end,
}
