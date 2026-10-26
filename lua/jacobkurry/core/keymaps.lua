-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights on Escape" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- toggle comments (built-in gc/gcc; Ctrl+/ arrives as <C-_> in most terminals)
for _, lhs in ipairs({ "<leader>/", "<C-/>", "<C-_>" }) do
  keymap.set("n", lhs, "gcc", { remap = true, desc = "Toggle comment on line" })
  keymap.set("x", lhs, "gc", { remap = true, desc = "Toggle comment on selection" })
end

-- increment/decrement numbers
keymap.set("n", "+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "-", "<C-x>", { desc = "Decrement number" })

-- indenting in visual mode
keymap.set("v", "<", "<gv", { desc = "Indent left" })
keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- fix pasting
keymap.set("n", "p", "P", { desc = "Paste before cursor" })

-- deal with line wrapping
keymap.set("n", "<up>", "gk", { desc = "Move up in wrapped line" })
keymap.set("n", "<down>", "gj", { desc = "Move down in wrapped line" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically (right)" }) -- split window vertically to the right
keymap.set("n", "<leader>sV", function()
  vim.cmd("split")
  vim.cmd("wincmd H")
end, { desc = "Split window vertically (left)" }) -- split window vertically to the left
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally (below)" }) -- split window horizontally below
keymap.set("n", "<leader>sH", function()
  vim.cmd("split")
  vim.cmd("wincmd K")
end, { desc = "Split window horizontally (above)" }) -- split window horizontally above
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
keymap.set("n", "<leader>sw", "<C-w>x", { desc = "Swap windows" }) -- swap current window with next
keymap.set("n", "<leader>s<", "<C-w><", { desc = "Decrease window width" }) -- decrease window width
keymap.set("n", "<leader>s>", "<C-w>>", { desc = "Increase window width" }) -- increase window width
keymap.set("n", "<leader>s-", "<C-w>-", { desc = "Decrease window height" }) -- decrease window height
keymap.set("n", "<leader>s+", "<C-w>+", { desc = "Increase window height" }) -- increase window height

-- window navigation
keymap.set("n", "<leader>i", "<C-w>k", { desc = "Focus window up" })
keymap.set("n", "<leader>k", "<C-w>j", { desc = "Focus window down" })
keymap.set("n", "<leader>j", "<C-w>h", { desc = "Focus window left" })
keymap.set("n", "<leader>l", "<C-w>l", { desc = "Focus window right" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Run Java file
keymap.set("n", "<leader>rj", ":!javac % && java %:r<CR>", { desc = "Compile and run Java file" })

-- Format file: <leader>fm is defined in plugins/formatting.lua (conform, with LSP fallback)

-- Test Runner Keymaps (Gradle/JUnit optimized)
local test_runner = require("jacobkurry.core.test-runner")

-- Run test method at cursor (single test)
keymap.set("n", "<leader>tnt", function()
  test_runner.run_test_method()
end, { desc = "Run nearest test" })

-- Run all tests in current file
keymap.set("n", "<leader>trf", function()
  test_runner.run_test_file()
end, { desc = "Run tests in file" })

-- Run all tests in package (like IntelliJ)
keymap.set("n", "<leader>trp", function()
  test_runner.run_test_package()
end, { desc = "Run tests in package" })

-- Run all tests in suite (entire project)
keymap.set("n", "<leader>tra", function()
  test_runner.run_all_tests()
end, { desc = "Run all tests in suite" })

-- Toggle test summary (neotest)
keymap.set("n", "<leader>tts", function()
  test_runner.toggle_test_summary()
end, { desc = "Toggle test summary" })

-- Open test output (neotest)
keymap.set("n", "<leader>tto", function()
  test_runner.open_test_output()
end, { desc = "Open test output" })

-- Stop/close test run
keymap.set("n", "<leader>tsx", function()
  test_runner.stop_tests()
end, { desc = "Stop test run" })

-- Run tests with coverage (Gradle projects with Jacoco)
keymap.set("n", "<leader>tcov", function()
  test_runner.run_tests_with_coverage()
end, { desc = "Run tests with coverage" })

-- Open coverage report in browser
keymap.set("n", "<leader>tco", function()
  test_runner.open_coverage_report()
end, { desc = "Open coverage report" })

