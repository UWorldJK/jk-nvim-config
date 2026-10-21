return {
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-java")({
            -- Configure for both Gradle and standalone Java projects
            junit_jar = vim.fn.expand("~/.local/share/nvim/neotest-java/junit-platform-console-standalone-1.10.0.jar"),
          }),
        },
        icons = {
          expanded = "▾",
          collapse = "▸",
          child_prefix = "├",
          child_indent = "│",
          final_child_prefix = "└",
          final_child_indent = " ",
          non_collapsible = "─",
          passed = "✓",
          running = "",
          failed = "✗",
          unknown = "?",
        },
        output = {
          open_on_run = false,
        },
      })
    end,
  }
}
