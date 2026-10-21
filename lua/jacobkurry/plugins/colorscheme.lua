return {
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    config = function()
      require("vscode").setup({
        transparent = false,
        italic_comments = true,
        disable_nvimtree_bg = true,
      })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#143652"
      local bg_search = "#0A64AC"
      local bg_visual = "#275378"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998"

      require("tokyonight").setup({
        style = "night",
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = bg_dark
          colors.bg_float = bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = bg_dark
          colors.bg_statusline = bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight", -- default colorscheme on startup
    },
    config = function()
      -- Set default colorscheme
      vim.cmd([[colorscheme tokyonight]])

      -- Keymap to cycle between colorschemes
      vim.keymap.set("n", "<leader>cs", function()
        local current = vim.g.colors_name
        if current and current:match("tokyonight") then
          vim.cmd([[colorscheme catppuccin]])
          vim.notify("Switched to Catppuccin", vim.log.levels.INFO)
        elseif current == "catppuccin" then
          vim.cmd([[colorscheme vscode]])
          vim.notify("Switched to VS Code", vim.log.levels.INFO)
        else
          vim.cmd([[colorscheme tokyonight]])
          vim.notify("Switched to Tokyo Night", vim.log.levels.INFO)
        end
      end, { desc = "Cycle colorscheme" })
    end,
  },
}
