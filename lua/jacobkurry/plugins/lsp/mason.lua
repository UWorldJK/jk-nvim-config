return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"ts_ls", -- TypeScript/JavaScript language server (formerly tsserver)
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"gopls", -- Go language server
				"jdtls", -- Java language server
				"yamlls", -- YAML language server
				"dockerls", -- Docker language server
				"docker_compose_language_service", -- Docker Compose language server
				"helm_ls", -- Helm language server
				"jsonls", -- JSON language server for better JSON/YAML support
			},
			-- handlers are configured here
			handlers = {
				-- default handler for installed servers
				function(server_name)
					local lspconfig = _G.lspconfig_module
					local capabilities = _G.lsp_capabilities

					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["svelte"] = function()
					local lspconfig = _G.lspconfig_module
					local capabilities = _G.lsp_capabilities

					-- configure svelte server
					lspconfig["svelte"].setup({
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							vim.api.nvim_create_autocmd("BufWritePost", {
								pattern = { "*.js", "*.ts" },
								callback = function(ctx)
									-- Here use ctx.match instead of ctx.file
									client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
								end,
							})
						end,
					})
				end,
				["graphql"] = function()
					local lspconfig = _G.lspconfig_module
					local capabilities = _G.lsp_capabilities

					-- configure graphql language server
					lspconfig["graphql"].setup({
						capabilities = capabilities,
						filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
					})
				end,
				["emmet_ls"] = function()
					local lspconfig = _G.lspconfig_module
					local capabilities = _G.lsp_capabilities

					-- configure emmet language server
					lspconfig["emmet_ls"].setup({
						capabilities = capabilities,
						filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
					})
				end,
				["lua_ls"] = function()
					local lspconfig = _G.lspconfig_module
					local capabilities = _G.lsp_capabilities

					-- configure lua server (with special settings)
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								-- make the language server recognize "vim" global
								diagnostics = {
									globals = { "vim" },
								},
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					})
				end,
				["yamlls"] = function()
					local lspconfig = _G.lspconfig_module
					local capabilities = _G.lsp_capabilities

					-- configure yaml language server
					lspconfig["yamlls"].setup({
						capabilities = capabilities,
						settings = {
							yaml = {
								schemaStore = {
									enable = true,
									url = "https://www.schemastore.org/api/json/catalog.json",
								},
								schemas = {
									-- Only apply schemas to non-template files
									["https://raw.githubusercontent.com/instrumenta/kubernetesjson-schema/master/v1.28.0-standalone-strict/all.json"] = {
										"k8s/*.yaml",
										"k8s/**/*.yaml",
										"kubernetes/*.yaml",
										"kubernetes/**/*.yaml",
										"!**/templates/**",
										"!**/helm/**",
									},
									["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
									["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
									["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
									["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
									["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
									["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
									["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
									["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
									["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
									["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
									["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
								},
								format = { enable = true },
								validate = { enable = true },
								completion = true,
								hover = true,
								implicitFlowLevel = 8,
								indentation = 2,
								-- Ignore validation for files with Go template syntax
								disablePatterns = {
									"**/templates/**/*.yaml",
									"**/templates/**/*.yml",
									"**/helm/**/*.yaml",
									"**/helm/**/*.yml",
									"*Chart.yaml",
									"*Chart.yml",
									"*values.yaml",
									"*values.yml",
									"*values*.yaml",
									"*values*.yml",
								},
							},
						},
					})
				end,
				["dockerls"] = function()
					local lspconfig = _G.lspconfig_module
					local capabilities = _G.lsp_capabilities

					-- configure docker language server
					lspconfig["dockerls"].setup({
						capabilities = capabilities,
					})
				end,
				["docker_compose_language_service"] = function()
					local lspconfig = _G.lspconfig_module
					local capabilities = _G.lsp_capabilities

					-- configure docker compose language server
					lspconfig["docker_compose_language_service"].setup({
						capabilities = capabilities,
					})
				end,
				["helm_ls"] = function()
					local lspconfig = _G.lspconfig_module
					local capabilities = _G.lsp_capabilities

					-- configure helm language server
					lspconfig["helm_ls"].setup({
						capabilities = capabilities,
						filetypes = { "helm" },
						-- Only attach to helm charts and templates
						autostart = true,
						settings = {
							["helm-ls"] = {
								yamlls = {
									enabled = false,
								},
								logLevel = "info",
							},
						},
					})
				end,
				["jsonls"] = function()
					local lspconfig = _G.lspconfig_module
					local capabilities = _G.lsp_capabilities

					-- configure json language server
					lspconfig["jsonls"].setup({
						capabilities = capabilities,
						settings = {
							json = {
								validate = { enable = true },
								format = { enable = true },
							},
						},
					})
				end,
				["ts_ls"] = function()
					local lspconfig = _G.lspconfig_module
					local capabilities = _G.lsp_capabilities

					-- configure TypeScript language server with enhanced React support
					lspconfig["ts_ls"].setup({
						capabilities = capabilities,
						filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "tsx", "jsx" },
						settings = {
							typescript = {
								inlayHints = {
									includeInlayParameterNameHints = "all",
									includeInlayParameterNameHintsWhenArgumentMatchesName = false,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
									includeInlayVariableTypeHints = false,
									includeInlayPropertyDeclarationTypeHints = true,
								},
								preferences = {
									quotePreference = "single",
									importModuleSpecifierPreference = "relative",
								},
								tsserver = {
									logVerbosity = "off",
								},
							},
							javascript = {
								inlayHints = {
									includeInlayParameterNameHints = "all",
									includeInlayParameterNameHintsWhenArgumentMatchesName = false,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
									includeInlayVariableTypeHints = false,
									includeInlayPropertyDeclarationTypeHints = true,
								},
								preferences = {
									quotePreference = "single",
									importModuleSpecifierPreference = "relative",
								},
							},
						},
					})
				end,
				["jdtls"] = function()
					-- jdtls is configured separately via nvim-jdtls plugin
					-- skip default configuration to avoid conflicts
				end,
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint", -- python linter
				"eslint_d", -- js linter
				"yamllint", -- yaml linter
				"hadolint", -- Dockerfile linter
			},
		})
	end,
}
