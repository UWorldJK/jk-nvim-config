# Neovim Keyboard Shortcuts Reference

**Leader Key:** `Space`

---

## Table of Contents
- [General & Navigation](#general--navigation)
- [LSP & IntelliSense](#lsp--intellisense)
- [File Explorer (nvim-tree)](#file-explorer-nvim-tree)
- [Fuzzy Finding (Telescope)](#fuzzy-finding-telescope)
- [Autocompletion](#autocompletion)
- [Window & Tab Management](#window--tab-management)
- [Code Editing](#code-editing)
- [Comments](#comments)
- [Escape & Exit Sequences](#escape--exit-sequences)

---

## General & Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `jk` | Exit Insert Mode | Quick escape from insert mode |
| `<Space>nh` | Clear Search Highlights | Remove search highlighting |
| `<Space>+` | Increment Number | Increase number under cursor |
| `<Space>-` | Decrement Number | Decrease number under cursor |

---

## LSP & IntelliSense

These shortcuts provide IDE-like features (go-to-definition, autocomplete, etc.):

| Key | Action | Description |
|-----|--------|-------------|
| `gd` | Go to Definition | Jump to definition (command-click equivalent) |
| `gD` | Go to Declaration | Jump to declaration |
| `gR` | Show References | Show all references using Telescope |
| `gi` | Go to Implementation | Jump to implementation |
| `gt` | Go to Type Definition | Jump to type definition |
| `K` | Hover Documentation | Show documentation for symbol under cursor |
| `<Space>ca` | Code Actions | Show available code actions |
| `<Space>rn` | Rename Symbol | Smart rename across project |
| `<Space>D` | Buffer Diagnostics | Show diagnostics for current file |
| `<Space>d` | Line Diagnostics | Show diagnostics for current line |
| `[d` | Previous Diagnostic | Jump to previous diagnostic |
| `]d` | Next Diagnostic | Jump to next diagnostic |
| `<Space>rs` | Restart LSP | Restart language server |

**Tip:** These keybindings work when a language server is attached to the buffer.

---

## File Explorer (nvim-tree)

| Key | Action | Description |
|-----|--------|-------------|
| `<Space>ee` | Toggle File Explorer | Open/close file tree |
| `<Space>ef` | Toggle on Current File | Open file explorer focused on current file |
| `<Space>ec` | Collapse Explorer | Collapse all folders |
| `<Space>er` | Refresh Explorer | Refresh file tree |

### Inside nvim-tree:
- `Enter` - Open file/folder
- `a` - Create new file
- `d` - Delete file
- `r` - Rename file
- `x` - Cut file
- `c` - Copy file
- `p` - Paste file
- `y` - Copy filename
- `Y` - Copy relative path
- `gy` - Copy absolute path
- `q` - Close explorer

---

## Fuzzy Finding (Telescope)

| Key | Action | Description |
|-----|--------|-------------|
| `<Space>ff` | Find Files | Fuzzy find files in current directory |
| `<Space>fr` | Recent Files | Find recently opened files |
| `<Space>fs` | Find String | Live grep search in project |
| `<Space>fc` | Find Under Cursor | Search for word under cursor |
| `<Space>ft` | Find TODOs | Search for TODO comments |

### Inside Telescope (Insert Mode):
| Key | Action |
|-----|--------|
| `Ctrl+k` | Move to previous result |
| `Ctrl+j` | Move to next result |
| `Ctrl+q` | Send to quickfix list |
| `Esc` | Close Telescope |
| `Enter` | Open selected file |

---

## Autocompletion

These shortcuts work in **Insert Mode** when the completion menu appears:

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+k` | Previous Suggestion | Move to previous completion item |
| `Ctrl+j` | Next Suggestion | Move to next completion item |
| `Ctrl+Space` | Trigger Completion | Manually show completion menu |
| `Ctrl+e` | Abort Completion | Close completion menu |
| `Ctrl+b` | Scroll Docs Up | Scroll documentation window up |
| `Ctrl+f` | Scroll Docs Down | Scroll documentation window down |
| `Enter` | Confirm Selection | Accept completion (only if explicitly selected) |

**Tip:** Autocompletion shows automatically as you type when LSP is active.

---

## Window & Tab Management

### Window Splits
| Key | Action | Description |
|-----|--------|-------------|
| `<Space>sv` | Split Vertically | Create vertical split |
| `<Space>sh` | Split Horizontally | Create horizontal split |
| `<Space>se` | Equal Splits | Make splits equal size |
| `<Space>sx` | Close Split | Close current split window |

### Tabs
| Key | Action | Description |
|-----|--------|-------------|
| `<Space>to` | Open New Tab | Create new tab |
| `<Space>tx` | Close Tab | Close current tab |
| `<Space>tn` | Next Tab | Go to next tab |
| `<Space>tp` | Previous Tab | Go to previous tab |
| `<Space>tf` | Buffer in New Tab | Open current buffer in new tab |

---

## Code Editing

### Substitute (Replace)
| Key | Action | Description |
|-----|--------|-------------|
| `s{motion}` | Substitute with Motion | Substitute with motion (e.g., `siw` to substitute word) |
| `ss` | Substitute Line | Substitute entire line |
| `S` | Substitute to EOL | Substitute to end of line |
| `s` (Visual) | Substitute Selection | Substitute visual selection |

---

## Comments

| Key | Action | Description |
|-----|--------|-------------|
| `gcc` | Toggle Line Comment | Comment/uncomment current line |
| `gc{motion}` | Comment with Motion | Comment with motion (e.g., `gcap` for paragraph) |
| `gbc` | Toggle Block Comment | Block comment current line |
| `gb{motion}` | Block Comment Motion | Block comment with motion |

In **Visual Mode:**
- `gc` - Comment selection
- `gb` - Block comment selection

---

## Escape & Exit Sequences

| From Mode | Key | Result |
|-----------|-----|--------|
| Insert Mode | `jk` | Return to Normal mode |
| Insert Mode | `Esc` | Return to Normal mode |
| Visual Mode | `Esc` | Return to Normal mode |
| Telescope | `Esc` | Close Telescope window |
| Completion Menu | `Ctrl+e` | Close completion menu |
| nvim-tree | `q` | Close file explorer |
| Normal Mode | `:q` | Quit Neovim (if no unsaved changes) |
| Normal Mode | `:q!` | Quit without saving |
| Normal Mode | `:wq` | Save and quit |

---

## Tips & Tricks

1. **Command-Click Equivalent:** Use `gd` to jump to definitions (like Cmd+Click in IDEs)

2. **Creating Files:**
   - Use `<Space>ee` to open file explorer
   - Press `a` to create a new file
   - Type filename and press Enter

3. **Filtering/Searching:**
   - `<Space>ff` - Quick file search
   - `<Space>fs` - Search within file contents
   - `/` in normal mode - Search in current file

4. **Navigation:**
   - `Ctrl+o` - Jump back to previous location
   - `Ctrl+i` - Jump forward to next location
   - `%` - Jump between matching brackets

5. **Using Autocomplete:**
   - Start typing - completion appears automatically
   - `Ctrl+k/j` to navigate suggestions
   - `Enter` to confirm
   - `Ctrl+e` to dismiss

---

## Language Server Support

Your configuration supports LSP for:
- JavaScript/TypeScript (`tsserver`)
- Python (`pyright`)
- Go (`gopls`)
- Java (`jdtls`)
- C++ (`clangd`)
- Lua (`lua_ls`)
- HTML, CSS, Svelte, GraphQL, and more

**Note:** After updating the configuration, restart Neovim and the language servers will auto-install via Mason.
