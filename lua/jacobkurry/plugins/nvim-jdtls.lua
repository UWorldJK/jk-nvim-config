return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },
	config = function()
		local jdtls = require("jdtls")

		-- Find the jdtls installation path from Mason
		local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
		local jdtls_path = mason_path

		-- Determine OS-specific config (for Apple Silicon)
		local config_path = jdtls_path .. "/config_mac_arm"

		-- Find the launcher jar
		local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

		-- Data directory for workspace
		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

		-- Get capabilities from cmp_nvim_lsp if available
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if ok then
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		end

		local config = {
			cmd = {
				"/opt/homebrew/opt/openjdk@25/bin/java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xmx1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens", "java.base/java.util=ALL-UNNAMED",
				"--add-opens", "java.base/java.lang=ALL-UNNAMED",
				"-jar", launcher_jar,
				"-configuration", config_path,
				"-data", workspace_dir,
			},
			root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
			settings = {
				java = {
					eclipse = {
						downloadSources = true,
					},
					configuration = {
						updateBuildConfiguration = "interactive",
					},
					maven = {
						downloadSources = true,
					},
					implementationsCodeLens = {
						enabled = true,
					},
					referencesCodeLens = {
						enabled = true,
					},
					references = {
						includeDecompiledSources = true,
					},
					format = {
						enabled = true,
					},
				},
				signatureHelp = { enabled = true },
				completion = {
					favoriteStaticMembers = {
						"org.hamcrest.MatcherAssert.assertThat",
						"org.hamcrest.Matchers.*",
						"org.hamcrest.CoreMatchers.*",
						"org.junit.jupiter.api.Assertions.*",
						"java.util.Objects.requireNonNull",
						"java.util.Objects.requireNonNullElse",
						"org.mockito.Mockito.*",
					},
				},
				contentProvider = { preferred = "fernflower" },
				extendedClientCapabilities = jdtls.extendedClientCapabilities,
				sources = {
					organizeImports = {
						starThreshold = 9999,
						staticStarThreshold = 9999,
					},
				},
				codeGeneration = {
					toString = {
						template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
					},
					useBlocks = true,
				},
			},
			flags = {
				allow_incremental_sync = true,
			},
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Regular LSP keybindings are already set via LspAttach autocmd in lspconfig.lua

				-- Java-specific keybindings
				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "<leader>co", jdtls.organize_imports, { desc = "Organize Imports", buffer = bufnr })
				vim.keymap.set("n", "<leader>tc", jdtls.test_class, { desc = "Test Class", buffer = bufnr })
				vim.keymap.set("n", "<leader>tm", jdtls.test_nearest_method, { desc = "Test Method", buffer = bufnr })
				vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, { desc = "Extract Variable", buffer = bufnr })
				vim.keymap.set("v", "<leader>ev", function()
					jdtls.extract_variable(true)
				end, { desc = "Extract Variable", buffer = bufnr })
				vim.keymap.set("n", "<leader>ec", jdtls.extract_constant, { desc = "Extract Constant", buffer = bufnr })
				vim.keymap.set("v", "<leader>ec", function()
					jdtls.extract_constant(true)
				end, { desc = "Extract Constant", buffer = bufnr })
				vim.keymap.set("v", "<leader>em", function()
					jdtls.extract_method(true)
				end, { desc = "Extract Method", buffer = bufnr })
			end,
		}

		-- Start or attach to jdtls
		jdtls.start_or_attach(config)
	end,
}
