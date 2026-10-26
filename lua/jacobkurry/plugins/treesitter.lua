-- nvim-treesitter `main` branch: setup() no longer takes highlight/indent/ensure_installed.
-- Parsers are installed with install() (needs the `tree-sitter` CLI) and
-- highlighting/indent are started per buffer from a FileType autocmd.
local parsers = {
  "json",
  "javascript",
  "typescript",
  "tsx",
  "yaml",
  "html",
  "css",
  "prisma",
  "markdown",
  "markdown_inline",
  "svelte",
  "graphql",
  "bash",
  "lua",
  "vim",
  "dockerfile",
  "gitignore",
  "query",
  "vimdoc",
  "c",
  "python",
  "go",
  "java",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      -- ensure these language parsers are installed
      if vim.fn.executable("tree-sitter") == 1 then
        treesitter.install(parsers)
      else
        -- deferred so it doesn't stack with startup messages into a hit-enter prompt
        vim.schedule(function()
          vim.notify_once(
            "nvim-treesitter: `tree-sitter` CLI not found, parsers not installed (brew install tree-sitter-cli)",
            vim.log.levels.WARN
          )
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        callback = function(args)
          -- enable syntax highlighting (no-op when the parser is missing)
          if not pcall(vim.treesitter.start, args.buf) then
            return
          end
          -- enable indentation
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    -- enable autotagging (no longer configured through nvim-treesitter)
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
