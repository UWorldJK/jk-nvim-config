-- Test Runner Utilities for Gradle/JUnit/Cucumber projects
-- Provides IntelliJ-like test execution capabilities

local M = {}

-- Detect if project is gradle-based
local function is_gradle_project()
  return vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1
end

-- Get the gradle wrapper or gradle command
local function get_gradle_command()
  if vim.fn.executable("./gradlew") == 1 then
    return "./gradlew"
  elseif vim.fn.executable("gradlew") == 1 then
    return "gradlew"
  else
    return "gradle"
  end
end

-- Get package name from Java file
local function get_package_from_file(file_path)
  local content = vim.fn.readfile(file_path)
  for _, line in ipairs(content) do
    if string.match(line, "^package%s+") then
      local package = string.match(line, "^package%s+([%w%.]+)")
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

-- Run test using Gradle (most reliable for Gradle projects)
function M.run_gradle_test(test_filter)
  if not is_gradle_project() then
    vim.notify("Not a Gradle project", vim.log.levels.WARN)
    return
  end

  local gradle = get_gradle_command()
  local cmd = gradle .. " test"

  if test_filter then
    cmd = cmd .. " --tests=" .. test_filter
  end

  -- Create a temporary buffer to show output
  vim.cmd("new")
  vim.cmd("term " .. cmd)
  vim.notify("Running: " .. cmd, vim.log.levels.INFO)
end

-- Run test method at cursor using Gradle
function M.run_test_method()
  local current_file = vim.fn.expand("%:p")
  local class_name = file_to_class_name(current_file)

  if not class_name then
    vim.notify("Could not determine test class", vim.log.levels.WARN)
    return
  end

  -- Get method name - simple heuristic: find "def testXxx()" or "@Test public void testXxx()"
  local row = vim.fn.line(".")
  local content = vim.fn.readfile(current_file)

  local method_name = nil
  for i = row, 1, -1 do
    local line = content[i]
    if line:match("public%s+void%s+(%w+)") then
      method_name = line:match("public%s+void%s+(%w+)")
      break
    elseif line:match("def%s+(%w+)") then
      method_name = line:match("def%s+(%w+)")
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
  if not is_gradle_project() then
    vim.notify("Not a Gradle project", vim.log.levels.WARN)
    return
  end

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
  if not is_gradle_project() then
    vim.notify("Not a Gradle project", vim.log.levels.WARN)
    return
  end

  local gradle = get_gradle_command()
  vim.cmd("new")
  vim.cmd("term " .. gradle .. " test")
  vim.notify("Running all tests...", vim.log.levels.INFO)
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

-- Stop running tests
function M.stop_tests()
  vim.cmd("TermClose")
  vim.notify("Tests stopped", vim.log.levels.INFO)
end

-- Run tests with coverage (Gradle only)
-- Falls back to regular test run if Jacoco not configured
function M.run_tests_with_coverage()
  if not is_gradle_project() then
    vim.notify("Coverage reports require Gradle", vim.log.levels.WARN)
    return
  end

  local gradle = get_gradle_command()
  vim.cmd("new")
  vim.cmd("term " .. gradle .. " test")
  vim.notify("Running tests...", vim.log.levels.INFO)
end

-- Open coverage report in default browser
function M.open_coverage_report()
  local coverage_report = "build/reports/jacoco/test/html/index.html"

  if vim.fn.filereadable(coverage_report) == 0 then
    vim.notify("Coverage report not found. Run tests with coverage first.", vim.log.levels.WARN)
    return
  end

  local report_path = vim.fn.getcwd() .. "/" .. coverage_report
  local cmd = "open '" .. report_path .. "'"

  vim.fn.system(cmd)
  vim.notify("Opening coverage report...", vim.log.levels.INFO)
end

return M
