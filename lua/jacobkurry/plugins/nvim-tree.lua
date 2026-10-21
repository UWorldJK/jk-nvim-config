return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Custom on_attach function for nvim-tree keymaps
    local function on_attach(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = "nvimtree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Apply default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- Custom mappings
      vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
      vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
      vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
      vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
      vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split (Right)'))
      vim.keymap.set('n', 'V', function()
        api.node.open.vertical()
        vim.cmd("wincmd L")
      end, opts('Open: Vertical Split (Left of Main Window)'))
      vim.keymap.set('n', 'x', api.node.open.horizontal, opts('Open: Horizontal Split'))
      vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
      vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
    end

    nvimtree.setup({
      on_attach = on_attach,
      system_open = {
        cmd = 'open',
        args = {},
      },
      view = {
        width = {
          max = -1,
        },
        relativenumber = true,
      },
      reload_on_bufenter = true,
      hijack_directories = {
        enable = false,
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      sync_root_with_cwd = false,
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      git = {
        enable = false,
        ignore = false,
      },
      filters = {
        custom = { ".DS_Store", "__pycache__" },
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open = "",
            },
          },
        },
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
    })

    -- set keymaps
    local keymap = vim.keymap

    keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>n", "<cmd>NvimTreeFindFile<CR><cmd>NvimTreeFocus<CR>", { desc = "Find file in NvimTree" })
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
  end,
  init = function()
    -- Auto-open nvim-tree when opening a directory
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function(data)
        local directory = vim.fn.isdirectory(data.file) == 1
        if not directory then
          return
        end
        vim.cmd.enew()
        vim.cmd.bw(data.buf)
        vim.cmd.cd(data.file)
        require("nvim-tree.api").tree.open()
      end,
    })
  end,
}
