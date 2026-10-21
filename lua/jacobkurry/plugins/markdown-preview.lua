return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
  keys = {
    { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Markdown preview" },
    { "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop preview" },
  },
}
