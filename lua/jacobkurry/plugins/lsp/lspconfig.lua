return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", ft = "lua", opts = {} }, -- replaces neodev (which only hooks the old lspconfig setup)
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- Change the Diagnostic symbols in the sign column (gutter)
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    -- used to enable autocompletion (applies to every lsp server config)
    vim.lsp.config("*", {
      capabilities = cmp_nvim_lsp.default_capabilities(),
    })

    -- Per-server overrides. These merge on top of nvim-lspconfig's defaults in lsp/<name>.lua.
    -- (mason-lspconfig v2 removed `handlers`, so servers must be configured here.)

    -- configure svelte server
    vim.lsp.config("svelte", {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePost", {
          group = vim.api.nvim_create_augroup("UserSvelteTsJs" .. bufnr, { clear = true }),
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            -- Here use ctx.match instead of ctx.file
            client:notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    })

    -- configure graphql language server
    vim.lsp.config("graphql", {
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    -- configure emmet language server
    vim.lsp.config("emmet_ls", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    -- configure lua server (with special settings)
    vim.lsp.config("lua_ls", {
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

    -- configure yaml language server
    vim.lsp.config("yamlls", {
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
          -- Ignore validation for files in templates or helm directories
          disablePatterns = {
            "**/templates/**",
            "**/helm/**",
          },
        },
      },
    })

    -- configure helm language server
    vim.lsp.config("helm_ls", {
      filetypes = { "helm" },
      settings = {
        ["helm-ls"] = {
          yamlls = {
            enabled = false,
          },
          logLevel = "info",
        },
      },
    })

    -- configure json language server
    vim.lsp.config("jsonls", {
      settings = {
        json = {
          validate = { enable = true },
          format = { enable = true },
        },
      },
    })

    -- configure TypeScript language server with enhanced React support
    local ts_js_settings = {
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
    }
    vim.lsp.config("ts_ls", {
      filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "tsx", "jsx" },
      settings = {
        typescript = vim.tbl_extend("force", ts_js_settings, { tsserver = { logVerbosity = "off" } }),
        javascript = ts_js_settings,
      },
    })

    -- install servers and enable them (vim.lsp.enable) once installed
    require("mason-lspconfig").setup({
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
      automatic_enable = {
        -- jdtls is started by nvim-jdtls (see nvim-jdtls.lua); enabling it here too spawns a second client
        exclude = { "jdtls" },
      },
    })
  end,
}
