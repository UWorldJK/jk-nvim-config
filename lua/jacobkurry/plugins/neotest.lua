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
          -- junit_jar left unset: neotest-java finds its pinned jar in stdpath("data")/neotest-java
          -- (install/update it with :NeotestJava setup)
          require("neotest-java")({}),
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
