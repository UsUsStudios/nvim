return {
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		config = function()
			local jdtls = require("jdtls")

			-- Determine OS
			local os_name = vim.loop.os_uname().sysname
			local system = "linux"
			if os_name:find("Windows") then
				system = "win"
			elseif os_name:find("Darwin") then
				system = "mac"
			end

			-- Find JARs automatically
			local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
			local jdtls_path = mason_packages .. "/jdtls"
			local launcher = vim.split(vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"), "\n")[1]
			local config_dir = jdtls_path .. "/config_" .. system

			-- Unique workspace directory per project
			local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
			local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

			-- Full config
			local config = {
				cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-javaagent:" .. jdtls_path .. "/lombok.jar",
					"-Xmx4g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens", "java.base/java.util=ALL-UNNAMED",
					"--add-opens", "java.base/java.lang=ALL-UNNAMED",
					"-jar", launcher,
					"-configuration", config_dir,
					"-data", workspace_dir,
				},

				root_dir = require("jdtls.setup").find_root({ ".git", "build.gradle", "pom.xml", "mvnw", "gradlew" }),

				settings = {
					java = {
						configuration = {
							runtimes = {
								{
									name = "OpenJDK-21",
									path = "/usr/bin",
								},
							},
						},
						codeGeneration = {
							toString = {
								template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
							},
						},
						completion = {
							favoriteStaticMembers = {
								"org.junit.Assert.*",
								"org.junit.Assume.*",
								"org.junit.jupiter.api.Assertions.*",
								"org.mockito.Mockito.*",
								"org.mockito.ArgumentMatchers.*",
								"org.mockito.Answers.*",
							},
						},
						sources = {
							organizeImports = {
								starThreshold = 9999,
								staticStarThreshold = 9999,
							},
						},
					},
				},

				-- KEY: Enable workspace-wide capabilities
				capabilities = vim.tbl_deep_extend("force",
					require("cmp_nvim_lsp").default_capabilities(),
					{
						workspace = {
							fileOperations = {
								didRename = true,
								willRename = true,
							},
						},
					}
				),

				on_attach = function(client, bufnr)
				-- Enable all jdtls extensions
					jdtls.setup_dap({ hotcodereplace = "auto" })
					jdtls.setup.add_commands()

					-- Keymaps for refactoring
					local opts = { buffer = bufnr }
					vim.keymap.set("n", "<leader>ro", jdtls.organize_imports, opts)
					vim.keymap.set("n", "<leader>rv", jdtls.extract_variable, opts)
					vim.keymap.set("v", "<leader>rv", function() jdtls.extract_variable(true) end, opts)
					vim.keymap.set("n", "<leader>rc", jdtls.extract_constant, opts)
					vim.keymap.set("v", "<leader>rc", function() jdtls.extract_constant(true) end, opts)
					vim.keymap.set("v", "<leader>rm", function() jdtls.extract_method(true) end, opts)

					-- Standard LSP keymaps
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)  -- This should work now!
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			}

			-- Start jdtls
			jdtls.start_or_attach(config)
		end,
	}