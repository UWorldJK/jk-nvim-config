# Neovim Test Setup Guide - JUnit & Gradle

This guide covers your enhanced Neovim testing setup with native Gradle integration for JUnit tests.

## What's Been Configured

### 1. **Test Runner Module** - Gradle Native
- **File**: `lua/jacobkurry/core/test-runner.lua`
- Direct Gradle test execution (`./gradlew test`)
- Automatic package/class/method detection from Java files
- IntelliJ-like test package execution
- Coverage report generation with Jacoco

### 2. **JDTLS** - Java Language Server
- **File**: `lua/jacobkurry/plugins/nvim-jdtls.lua`
- Direct test class/method execution via LSP
- `<leader>tc` - Run test class
- `<leader>tm` - Run test method
- Integrated refactoring tools

### 3. **Gradle Plugin** - Task Execution
- **File**: `lua/jacobkurry/plugins/gradle.lua`
- Execute arbitrary Gradle tasks with `<leader>Ge`
- Works with `gradle.nvim` plugin

### 4. **Neotest** - Optional Summary UI
- **File**: `lua/jacobkurry/plugins/neotest.lua`
- Optional test summary display
- Toggle with `<leader>tts`

## Keybindings Reference

### Running Tests with Gradle (Primary - IntelliJ Style)

| Keybinding | Action | What It Runs |
|---|---|---|
| `<leader>tnt` | Run nearest test | Test method at cursor (e.g., `gradlew test --tests=com.example.UserServiceTest.testFindUser`) |
| `<leader>trf` | Run tests in file | All tests in current file (entire class) |
| `<leader>trp` | Run tests in package | All tests in the same package (e.g., `com.example.*`) |
| `<leader>tra` | Run all tests | Entire test suite (`gradlew test`) |

### Test Output Control

| Keybinding | Action | Notes |
|---|---|---|
| `<leader>tts` | Toggle test summary | Shows/hides Neotest UI (if available) |
| `<leader>tto` | Open test output | Opens detailed test output (if Neotest available) |
| `<leader>tsx` | Stop/close tests | Closes test terminal window |

### Coverage & Advanced (Gradle)

| Keybinding | Action | Notes |
|---|---|---|
| `<leader>tcov` | Tests with coverage | Runs `gradlew test jacocoTestReport` (requires Jacoco) |

### JDTLS Integration (Alternative)

| Keybinding | Action | Notes |
|---|---|---|
| `<leader>tc` | Test class (via LSP) | Direct via Java Language Server |
| `<leader>tm` | Test method (via LSP) | Direct via Java Language Server |

### Gradle Task Execution

| Keybinding | Action | Notes |
|---|---|---|
| `<leader>Gg` | Open Gradle projects | Interactive Gradle project selector |
| `<leader>Ge` | Execute Gradle task | Run any Gradle task (e.g., `build`, `clean`, `test`, etc.) |
| `<leader>Gi` | Create new Gradle project | Initialize new Gradle project |
| `<leader>Gf` | Gradle favorites | Quick access to favorite tasks |

## How It Works

### For Gradle Projects

1. When you open a Java file in a Gradle project (detected by `build.gradle` or `build.gradle.kts`)
2. Neotest automatically loads the **gradle adapter**
3. Test execution runs via `./gradlew test` (or `gradlew`/`gradle` as fallback)
4. Test results are displayed in the Neotest UI

### For Cucumber Features

When you open `.feature` files:
- The `neotest-cucumber` adapter activates
- Steps are recognized from `src/test/java`
- Feature files from `src/test/resources/features` are indexed
- Run tests with the same keybindings as JUnit tests

### For Non-Gradle Java Projects

If no `build.gradle` is found:
- Falls back to `neotest-java` adapter
- Uses JUnit Platform standalone JAR
- Useful for simple Java projects

## Test File Patterns

### Recognized Test Files

The setup automatically detects:
- `*Test.java` (e.g., `UserServiceTest.java`)
- `*Tests.java` (e.g., `UserServiceTests.java`)
- `.feature` files (Cucumber scenarios)

### Project Structure Example

```
my-project/
├── build.gradle
├── src/
│   ├── main/java/
│   │   └── com/example/
│   │       └── UserService.java
│   └── test/
│       ├── java/
│       │   └── com/example/
│       │       ├── UserServiceTest.java
│       │       └── steps/
│       │           └── UserStepDefinitions.java
│       └── resources/
│           └── features/
│               └── user-management.feature
```

## Usage Examples

### Running a Single Test Method
1. Place cursor inside test method
2. Press `<leader>tnt` to run nearest test
3. Watch results in Neotest summary

### Running All Tests in a Test Class
1. Open the test class (e.g., `UserServiceTest.java`)
2. Press `<leader>trf` to run all tests in file
3. Press `<leader>tts` to toggle the test summary panel

### Running Tests in a Package
1. Open any test file in the package
2. Press `<leader>trp` to run all tests in that package directory
3. Useful for testing an entire feature module

### Running Complete Test Suite
1. Press `<leader>tra` to run all project tests
2. Open test output with `<leader>tto`
3. View failures and navigate to issues

### Generate Coverage Report
1. Press `<leader>tcov` (requires Gradle plugin like Jacoco)
2. Report generated in `build/reports/jacoco/test/html/`

## Configuration Customization

### Gradle Configuration

In `lua/jacobkurry/plugins/neotest.lua`, adjust:

```lua
require("neotest-gradle")({
  command = "./gradlew",  -- Change if using different Gradle distribution
  is_test_file = function(file_path)
    -- Customize what's recognized as a test file
    return string.match(file_path, "Test%.java$")
  end,
})
```

### Cucumber Configuration

Paths can be customized in the neotest setup:

```lua
require("neotest-cucumber")({
  features_path = "src/test/resources/features",  -- Where .feature files live
  steps_path = "src/test/java",                    -- Where step definitions live
})
```

## Troubleshooting

### Tests Not Running
1. Ensure `build.gradle` or `build.gradle.kts` exists in project root
2. Verify test files end with `Test.java` or `Tests.java`
3. Check that `./gradlew` is executable (or `gradle` is in PATH)
4. Open test output: `<leader>tto`

### Cucumber Tests Not Found
1. Verify `.feature` files are in `src/test/resources/features/`
2. Check step definitions are in `src/test/java/`
3. Ensure Cucumber/Gherkin is installed: `maven { id 'io.cucumber' }`

### Performance Issues
- For large test suites, run tests by package (`<leader>trp`) rather than all (`<leader>tra`)
- Results cache after first run; use `<leader>tts` to refresh

## Integration with Other Tools

### With DAP (Debugger)
- Set breakpoints with `<leader>b`
- Tests respect debug configuration
- Currently configured for Java debugging

### With Trouble
- Compile/test errors appear in Trouble window
- Navigate via `<leader>xx` (requires Trouble plugin)

### With Gradle
- Use `<leader>Ge` for custom Gradle tasks
- Save frequently used tasks as favorites

## Next Steps

1. **Run your first test**: Open a test file and press `<leader>tnt`
2. **Configure coverage**: Setup Jacoco in your `build.gradle` for `<leader>tcov`
3. **Customize keybindings**: Edit `lua/jacobkurry/core/keymaps.lua` to your preference
4. **Explore Cucumber**: Add `.feature` files to use BDD testing

## Files Modified

- `lua/jacobkurry/plugins/neotest.lua` - Enhanced with Gradle & Cucumber support
- `lua/jacobkurry/core/keymaps.lua` - Added test runner keybindings
- `lua/jacobkurry/core/test-runner.lua` - New utilities module

## Additional Resources

- **Neotest**: https://github.com/nvim-neotest/neotest
- **neotest-gradle**: https://github.com/nvim-neotest/neotest-gradle
- **Gradle**: https://gradle.org/
- **Cucumber**: https://cucumber.io/
