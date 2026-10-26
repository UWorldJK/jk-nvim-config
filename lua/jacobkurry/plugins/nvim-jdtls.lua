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

		local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "settings.gradle" }

		-- Get capabilities from cmp_nvim_lsp if available
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if ok then
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		end

		local function build_config(bufnr)
			local root_dir = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

			-- Data directory for workspace (one per project root, not per cwd)
			local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
			local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name

			return {
				cmd = {
					"/opt/homebrew/opt/openjdk@25/bin/java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Xmx1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens", "java.base/java.util=ALL-UNNAMED",
					"--add-opens", "java.base/java.lang=ALL-UNNAMED",
					"-jar", launcher_jar,
					"-configuration", config_path,
					"-data", workspace_dir,
				},
				root_dir = root_dir,
				settings = {
					java = {
						eclipse = {
							downloadSources = true,
						},
						configuration = {
							updateBuildConfiguration = "automatic",
							runtimes = {},
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
						gradle = {
							enabled = true,
							wrapper = {
								checksums = {},
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
				},
				flags = {
					allow_incremental_sync = true,
				},
				capabilities = capabilities,
				init_options = {
					bundles = {},
					extendedClientCapabilities = jdtls.extendedClientCapabilities,
				},
				on_attach = function(client, bufnr)
					-- Regular LSP keybindings are already set via LspAttach autocmd in lspconfig.lua

					-- Java-specific keybindings
					vim.keymap.set("n", "<leader>co", jdtls.organize_imports, { desc = "Organize Imports", buffer = bufnr })
					vim.keymap.set("n", "<leader>tc", jdtls.test_class, { desc = "Test Class", buffer = bufnr })
					vim.keymap.set("n", "<leader>tm", jdtls.test_nearest_method, { desc = "Test Method", buffer = bufnr })
					vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, { desc = "Extract Variable", buffer = bufnr })
					vim.keymap.set("v", "<leader>ev", function()
						jdtls.extract_variable(true)
					end, { desc = "Extract Variable", buffer = bufnr })
					-- <leader>eC, not <leader>ec: that one is NvimTreeCollapse
					vim.keymap.set("n", "<leader>eC", jdtls.extract_constant, { desc = "Extract Constant", buffer = bufnr })
					vim.keymap.set("v", "<leader>eC", function()
						jdtls.extract_constant(true)
					end, { desc = "Extract Constant", buffer = bufnr })
					vim.keymap.set("v", "<leader>em", function()
						jdtls.extract_method(true)
					end, { desc = "Extract Method", buffer = bufnr })
				end,
			}
		end

		-- Start or attach to jdtls for every Java buffer, not just the one that lazy-loaded this plugin
		local function attach(bufnr)
			jdtls.start_or_attach(build_config(bufnr), {}, { bufnr = bufnr })
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("UserJdtls", { clear = true }),
			pattern = "java",
			callback = function(args)
				attach(args.buf)
			end,
		})
		attach(vim.api.nvim_get_current_buf())
	end,
}
