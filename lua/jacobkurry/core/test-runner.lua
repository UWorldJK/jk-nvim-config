-- Test Runner Utilities for Gradle/JUnit/Cucumber projects
-- Provides IntelliJ-like test execution capabilities

local M = {}

-- Terminal buffer of the most recent test run (used by stop_tests)
local term_buf = nil

-- Find the Gradle project root for the current buffer (nil if not a Gradle project)
local function get_gradle_root()
  return vim.fs.root(0, { "gradlew", "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts" })
end

-- Get the gradle wrapper or gradle command
local function get_gradle_command(root)
  if vim.fn.executable(root .. "/gradlew") == 1 then
    return "./gradlew"
  else
    return "gradle"
  end
end

-- Get package name from Java file
local function get_package_from_file(file_path)
  if vim.fn.filereadable(file_path) == 0 then
    return nil
  end
  local content = vim.fn.readfile(file_path)
  for _, line in ipairs(content) do
    local package = string.match(line, "^package%s+([%w%.]+)")
    if package then
      return package
    end
  end
  return nil
end

-- Get class name from file path
local function get_class_from_file(file_path)
  local filename = vim.fn.fnamemodify(file_path, ":t")
  return string.match(filename, "^([%w_]+)%.java$")
end

-- Convert file path to package.Class format
local function file_to_class_name(file_path)
  local package = get_package_from_file(file_path)
  local class = get_class_from_file(file_path)

  if package and class then
    return package .. "." .. class
  elseif class then
    return class
  end
  return nil
end

-- Run a gradle command in a terminal split at the project root
local function run_gradle(args, message)
  local root = get_gradle_root()
  if not root then
    vim.notify("Not a Gradle project", vim.log.levels.WARN)
    return
  end

  local cmd = { get_gradle_command(root) }
  vim.list_extend(cmd, args)

  -- Create a temporary buffer to show output
  vim.cmd("new")
  vim.fn.jobstart(cmd, { term = true, cwd = root })
  term_buf = vim.api.nvim_get_current_buf()
  vim.notify(message or ("Running: " .. table.concat(cmd, " ")), vim.log.levels.INFO)
end

-- Run test using Gradle (most reliable for Gradle projects)
function M.run_gradle_test(test_filter)
  local args = { "test" }
  if test_filter then
    table.insert(args, "--tests=" .. test_filter)
  end
  run_gradle(args)
end

-- Run test method at cursor using Gradle
function M.run_test_method()
  local current_file = vim.fn.expand("%:p")
  local class_name = file_to_class_name(current_file)

  if not class_name then
    vim.notify("Could not determine test class", vim.log.levels.WARN)
    return
  end

  -- Get method name - walk up from the cursor to the nearest "void name(" declaration
  -- (JUnit 5 test methods are often package-private, so don't require "public")
  local row = vim.fn.line(".")
  local content = vim.api.nvim_buf_get_lines(0, 0, row, false)

  local method_name = nil
  for i = row, 1, -1 do
    method_name = content[i]:match("void%s+([%w_]+)%s*%(")
    if method_name then
      break
    end
  end

  if method_name then
    M.run_gradle_test(class_name .. "." .. method_name)
  else
    -- Run entire class if method not found
    M.run_gradle_test(class_name)
  end
end

-- Run all tests in current file
function M.run_test_file()
  local current_file = vim.fn.expand("%:p")
  local class_name = file_to_class_name(current_file)

  if not class_name then
    vim.notify("Could not determine test class", vim.log.levels.WARN)
    return
  end

  M.run_gradle_test(class_name)
end

-- Run all tests in package (directory of current file)
function M.run_test_package()
  local current_file = vim.fn.expand("%:p")
  local package = get_package_from_file(current_file)

  if package then
    -- Run all tests matching package pattern
    M.run_gradle_test(package .. ".*")
  else
    vim.notify("Could not determine package", vim.log.levels.WARN)
  end
end

-- Run all tests in the project
function M.run_all_tests()
  run_gradle({ "test" }, "Running all tests...")
end

-- Show test summary (neotest)
function M.toggle_test_summary()
  local ok, neotest = pcall(require, "neotest")
  if ok then
    neotest.summary.toggle()
  else
    vim.notify("Neotest not available", vim.log.levels.WARN)
  end
end

-- Open test output
function M.open_test_output()
  local ok, neotest = pcall(require, "neotest")
  if ok then
    neotest.output.open({ enter = true })
  else
    vim.notify("Neotest not available", vim.log.levels.WARN)
  end
end

-- Stop running tests (kills the job and closes the terminal from the last run)
function M.stop_tests()
  if not (term_buf and vim.api.nvim_buf_is_valid(term_buf)) then
    vim.notify("No test run to stop", vim.log.levels.INFO)
    return
  end

  local job = vim.b[term_buf].terminal_job_id
  if job then
    vim.fn.jobstop(job)
  end
  vim.api.nvim_buf_delete(term_buf, { force = true })
  term_buf = nil
  vim.notify("Tests stopped", vim.log.levels.INFO)
end

-- Run tests with coverage (Gradle only, requires the Jacoco plugin)
function M.run_tests_with_coverage()
  run_gradle({ "test", "jacocoTestReport" }, "Running tests with coverage...")
end

-- Open coverage report in default browser
function M.open_coverage_report()
  local root = get_gradle_root() or vim.fn.getcwd()
  local report_path = root .. "/build/reports/jacoco/test/html/index.html"

  if vim.fn.filereadable(report_path) == 0 then
    vim.notify("Coverage report not found. Run tests with coverage first.", vim.log.levels.WARN)
    return
  end

  vim.ui.open(report_path)
  vim.notify("Opening coverage report...", vim.log.levels.INFO)
end

return M
