# Future Neovim Improvements

This document compares your current Neovim configuration with LazyVim's approach and suggests potential improvements.

## Executive Summary

Your configuration is already quite sophisticated with strong Stripe-specific customizations. LazyVim offers some organizational patterns and plugins that could enhance your workflow without requiring a full migration.

---

## Architecture & Organization

### Current State
- Custom `packages/` directory structure
- Manual plugin organization by category
- Machine detection for Stripe-specific features

### LazyVim Approach
- `lua/config/` for core settings (autocmds, keymaps, options, lazy.lua)
- `lua/plugins/` for plugin specs (auto-loaded by lazy.nvim)
- Built-in extras system (`:LazyExtras` command)

### Recommendations

#### 1. Consider Adopting `lua/config/` Structure
**Benefits:**
- Clearer separation between core config and plugins
- More discoverable for other developers
- Aligns with emerging community conventions

**Migration:**
```
nvim/lua/config/
  ├── autocmds.lua    # Auto-commands
  ├── keymaps.lua     # Global keymaps
  ├── options.lua     # Vim options
  └── lazy.lua        # Plugin manager setup
```

**Effort:** Medium | **Impact:** Low-Medium (organizational clarity)

#### 2. Implement Extras System
Create a simple extras loader for optional features:

```lua
-- lua/config/extras.lua
local M = {}

M.available = {
  ["stripe"] = "lua.extras.stripe",
  ["ruby"] = "lua.extras.ruby",
  ["typescript"] = "lua.extras.typescript",
}

function M.load(extras)
  for _, extra in ipairs(extras) do
    if M.available[extra] then
      require(M.available[extra])
    end
  end
end

return M
```

**Effort:** Low | **Impact:** Medium (easier feature toggling)

---

## Missing LazyVim Plugins Worth Considering

### 1. Flash.nvim (High Priority)
**What:** Enhanced navigation that shows jump labels at the end of search matches
**Why:** Faster navigation than current search workflow
**Keymaps:**
- `s` - Flash jump
- `S` - Flash treesitter
- `r` - Remote flash

**Your Current Setup:** Standard `/` search with `vim-cool`
**Benefit:** Significantly faster file navigation, especially in large files

**Config Suggestion:**
```lua
{
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  },
}
```

**Effort:** Low | **Impact:** High

---

### 2. Grug-far.nvim (Medium Priority)
**What:** Search/replace in multiple files with live preview
**Why:** Better than Fugitive's `:Ggrep` + quickfix workflow

**Your Current Setup:** Likely using fzf-lua + quickfix or manual find/replace
**Benefit:** Visual feedback before applying changes across files

**Config Suggestion:**
```lua
{
  "MagicDuck/grug-far.nvim",
  opts = { headerMaxWidth = 80 },
  cmd = "GrugFar",
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.grug_far({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace",
    },
  },
}
```

**Effort:** Low | **Impact:** Medium

---

### 3. Mini.ai (High Priority)
**What:** Extended text objects for arguments, quotes, brackets, function calls
**Why:** More powerful than vim-surround alone

**Your Current Setup:** vim-surround for surroundings
**Benefit:** Work with function arguments (`via`), nested objects, custom patterns

**Example Use Cases:**
- `via` - Select inside argument
- `vaa` - Select around argument
- `vin(` - Select inside next parentheses
- `val(` - Select inside last parentheses

**Config Suggestion:**
```lua
{
  "echasnovski/mini.ai",
  event = "VeryLazy",
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
      },
    }
  end,
}
```

**Effort:** Low | **Impact:** High (daily editing efficiency)

---

### 4. ~~Todo-comments.nvim~~ ✅ INSTALLED
**What:** Highlight and search TODO, HACK, BUG, NOTE comments
**Why:** Better tracking of code TODOs

**Status:** ✅ Installed in `nvim/lua/packages/editing.lua`

**Keymaps:**
- `]t` / `[t` - Next/prev todo comment
- `<leader>st` - Search todos with fzf-lua
- `<leader>sT` - Search TODO/FIX/FIXME specifically

---

### 5. Bufferline.nvim (Low Priority)
**What:** Fancy-looking tabs with close buttons and file icons
**Why:** Visual buffer management

**Your Current Setup:** Standard buffer list via `:ls`
**Benefit:** Visual representation of open buffers

**Note:** This is mostly aesthetic. Your fzf-lua buffer switching (`<leader>sb`) is already efficient.

**Effort:** Low | **Impact:** Low (aesthetic)

---

### 6. ~~Noice.nvim~~ ✅ INSTALLED
**What:** Replaces UI for messages, cmdline, and popups
**Why:** More modern, less intrusive UI

**Status:** ✅ Installed in `nvim/lua/packages/ui.lua`

**Warning:** Described as "highly experimental" by LazyVim - monitor for issues

**Keymaps:**
- `<leader>snl` - Show last message
- `<leader>snh` - Show message history
- `<leader>sna` - Show all messages
- `<leader>snd` - Dismiss all notifications
- `<c-f>` / `<c-b>` - Scroll LSP hover docs

---

## Keymap Organization Suggestions

### Current State
- Global keymaps in `init.lua`
- Plugin-specific keymaps in plugin files
- Some LSP keymaps in `lsp/setup.lua`

### LazyVim Convention
Hierarchical prefix system with which-key groups:

| Prefix | Category |
|--------|----------|
| `<leader>b` | Buffers |
| `<leader>c` | Code (LSP actions) |
| `<leader>d` | Debug |
| `<leader>f` | Files |
| `<leader>g` | Git |
| `<leader>s` | Search |
| `<leader>t` | Test |
| `<leader>u` | UI toggles |
| `<leader>w` | Windows |
| `<leader>x` | Diagnostics/Trouble |
| `<leader><tab>` | Tabs |

### Your Current Prefixes
- `<leader>a` - Claude Code (good!)
- `<leader>b` - Comment boxes (conflicts with LazyVim buffers)
- `<leader>l` - LSP (LazyVim uses `<leader>c`)
- `<leader>m` - Marks
- `<leader>n` - Neogen annotations
- `<leader>s` - Search (matches LazyVim!)
- `<leader>x` - Trouble (matches LazyVim!)
- `<leader>y` - Yank filepath (nice!)

### Recommendations

#### 1. Consider Migrating LSP Keymaps
**Current:** `<leader>l` prefix for LSP
**LazyVim:** `<leader>c` prefix for code actions

**Rationale:**
- `<leader>c` is more mnemonic (c = code)
- Frees up `<leader>l` for other uses
- Aligns with community convention

**Migration:**
- `<leader>lr` → `<leader>cr` (rename)
- `<leader>lc` → `<leader>ca` (code action - more specific)
- `<leader>lt` → `<leader>ct` (type definition)

**Effort:** Low | **Impact:** Low (muscle memory retraining)

#### 2. Add Buffer Management Keymaps
**Currently:** Only fzf-lua buffer switching (`<leader>sb`)
**LazyVim:** Full buffer prefix (`<leader>b`)

**Suggestions:**
```lua
-- Buffer navigation
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
```

**Conflict:** Your `<leader>b` is used for comment boxes
**Solution:** Move comment boxes to `<leader>cb` (code boxes) or `<leader>/b`

**Effort:** Low | **Impact:** Medium (better buffer management)

#### 3. Add File Management Prefix
**LazyVim:** `<leader>f` for files (find, recent, etc.)
**Your Setup:** Files mixed into search (`<leader>s`)

**Suggestions:**
```lua
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent Files" })
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
```

**Note:** Keep `<leader><space>` for proximity-sorted file finding (it's great!)

**Effort:** Low | **Impact:** Low-Medium (organization)

---

## Configuration Patterns

### 1. Lazy-Loading Strategy

**Your Current Setup:** Mix of lazy and non-lazy loading
**LazyVim Approach:** Aggressive lazy-loading with:
- `event = "VeryLazy"` for most plugins
- `keys` for keymap-triggered plugins
- `cmd` for command-triggered plugins
- `ft` for filetype-specific plugins

**Recommendation:** Audit your plugin loading for startup time optimization

**Example Audit:**
```lua
-- Current (always loaded)
{
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
}

-- Optimized (lazy-loaded)
{
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    -- ... other keymaps
  },
  opts = {},
}
```

**Effort:** Medium | **Impact:** Medium (faster startup)

---

### 2. Keymap Definition Location

**Your Current Setup:** Keymaps split between `init.lua` and plugin files
**LazyVim Approach:** Keymaps defined in plugin specs using `keys` field

**Benefits:**
- Keymaps only registered when plugin loads
- Self-documenting plugin keybindings
- Easier to disable/override

**Example:**
```lua
-- Instead of defining in init.lua, define in plugin spec:
{
  "nvim-treesitter/nvim-treesitter",
  keys = {
    { "<c-space>", desc = "Increment Selection" },
    { "<bs>", desc = "Decrement Selection", mode = "x" },
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
```

**Effort:** Medium | **Impact:** Low-Medium (better organization)

---

## Feature Gaps Worth Addressing

### 1. Debug Adapter Protocol (DAP)
**What:** First-class debugging support in Neovim
**Why:** Step through code, set breakpoints, inspect variables

**Your Current Setup:** Likely using print statements or external debuggers
**LazyVim Provides:** nvim-dap with UI and language-specific adapters

**Languages You'd Benefit From:**
- Ruby (pay-server debugging)
- TypeScript/JavaScript (frontend debugging)
- Lua (Hammerspoon/Neovim plugin development)

**Effort:** High | **Impact:** High (for complex debugging scenarios)

---

### 2. Project-Specific Configuration
**What:** Per-project Neovim settings
**Why:** Different projects have different needs

**LazyVim Uses:** neoconf.nvim for `.neoconf.json` files

**Your Current Setup:** Machine detection (Stripe vs personal)
**Benefit:** Per-repo overrides (e.g., different formatters for different Stripe repos)

**Example Use Case:**
- pay-server uses Rubocop
- Other Ruby project uses Standard
- Configure per-project without conditional logic

**Effort:** Low | **Impact:** Medium (if you work on multiple Ruby codebases)

---

### 3. Aerial.nvim (Code Outline)
**What:** LSP-powered code outline sidebar
**Why:** Quick navigation in large files

**Your Current Setup:** Treesitter textobjects for navigation
**Benefit:** Visual overview of file structure

**Keymaps:**
- `<leader>cs` - Toggle code outline

**Effort:** Low | **Impact:** Low-Medium (useful for large files)

---

## Plugins You Have That LazyVim Doesn't (Keep These!)

### Excellent Unique Features
1. **Sourcegraph Integration** - Essential for Stripe
2. **Claude Code Integration** - Modern AI assistance
3. **VimFiler** - Your preferred file explorer
4. **Vimux** - tmux test running
5. **vim-tmux-navigator** - Seamless tmux integration
6. **vim-projectionist** - Alternate file navigation
7. **Proximity-sorted FZF** - Brilliant optimization
8. **vim-abolish** - Case coercion (crs, crc)
9. **neogen** - Function annotation generation
10. **comment-box.nvim** - ASCII comment boxes

**Recommendation:** Keep all of these! They're either better than LazyVim's approach or provide unique value.

---

## Plugins to Consider Replacing

### 1. VimFiler → Neo-tree or Oil.nvim
**Current:** VimFiler (older plugin, less maintained)
**LazyVim Uses:** Neo-tree (more modern, better Git integration)
**Alternative:** Oil.nvim (edit filesystem like a buffer)

**Recommendation:** Try neo-tree if VimFiler ever breaks, otherwise stick with what works

**Effort:** Low | **Impact:** Low (workflow change)

---

### 2. ~~Comment.nvim → ts-comments.nvim~~ ✅ REPLACED
**Status:** ✅ Replaced Comment.nvim with ts-comments.nvim in `nvim/lua/packages/editing.lua`

**Benefit:** Better handling of mixed-language files (e.g., JSX, Vue, embedded SQL)

**Notes:** Uses same `gc` keymaps as before, but now treesitter-aware

---

## LazyVim Features You Don't Need

### 1. Telescope → fzf-lua
**Your Choice:** fzf-lua (faster, native performance)
**LazyVim Default:** Telescope

**Recommendation:** Keep fzf-lua! It's faster and you've customized it well.

---

### 2. ~~Noice.nvim~~ ✅ INSTALLED
**Status:** ✅ Installed - monitoring for stability
**Note:** If you experience issues, it can be easily disabled by removing from `nvim/lua/packages/ui.lua`

---

### 3. Snacks.nvim
**LazyVim Uses:** Multi-purpose utility plugin
**Your Setup:** Discrete plugins for each feature

**Recommendation:** Stick with your approach (more modular, easier to debug)

---

## Implementation Priority

### High Priority (Do Soon)
1. **Flash.nvim** - Significantly better navigation
2. **Mini.ai** - Extended text objects for daily editing
3. **Audit lazy-loading** - Improve startup time

### Medium Priority (Nice to Have)
1. ~~**Todo-comments.nvim**~~ ✅ - Better TODO tracking
2. **Grug-far.nvim** - Multi-file search/replace
3. **Keymap reorganization** - Align with conventions
4. ~~**ts-comments.nvim**~~ ✅ - Better commenting

### Low Priority (Optional)
1. **Bufferline.nvim** - Visual buffer tabs
2. **Neo-tree** - Modern file explorer
3. **Extras system** - Feature toggling
4. **lua/config/ restructuring** - Organization

### Future Exploration
1. **DAP** - When you need serious debugging
2. **Neoconf** - If you work on multiple projects with different configs
3. ~~**Noice.nvim**~~ ✅ - Installed and testing

---

## Migration Strategy (If You Want to Go Further)

### Option 1: Incremental Adoption (Recommended)
1. Keep your current config as base
2. Add LazyVim plugins one at a time
3. Gradually adopt keymap conventions
4. Test each change in isolation

**Pros:** Low risk, learn incrementally
**Cons:** Takes longer

---

### Option 2: Parallel Config
1. Install LazyVim to `~/.config/nvim-lazyvim`
2. Try it for non-Stripe work
3. Port features you like back to main config

**Pros:** Safe experimentation
**Cons:** Maintaining two configs

**Command to try:**
```bash
NVIM_APPNAME=nvim-lazyvim nvim
```

---

### Option 3: Full Migration (Not Recommended)
LazyVim is opinionated and you have many Stripe-specific customizations. Full migration would lose:
- Sourcegraph integration
- Pay-server specific tooling
- Custom machine detection
- Proximity-sorted file finding

**Recommendation:** Cherry-pick features instead of full migration.

---

## Summary: Quick Wins

### ✅ Completed
1. ~~**ts-comments.nvim**~~ - Treesitter-aware commenting (replaced Comment.nvim)
2. ~~**todo-comments.nvim**~~ - TODO highlighting and navigation
3. ~~**noice.nvim**~~ - Modern UI for messages and cmdline

### Remaining Quick Wins

If you have 20 more minutes, do these two things:

1. **Install Flash.nvim** (~10 min)
   - Add plugin spec
   - Try `s` to jump around a file
   - Game-changing navigation

2. **Install Mini.ai** (~10 min)
   - Add plugin spec
   - Try `via` to select function arguments
   - Try `vin(` to select inside next parentheses

These two plugins integrate seamlessly with your existing config and require zero configuration changes beyond adding the plugin specs.

---

## Questions to Consider

1. **How often do you navigate large files?**
   - High: Install Flash.nvim immediately
   - Low: Maybe skip

2. **Do you work on multiple Ruby/TS projects with different conventions?**
   - Yes: Consider neoconf.nvim
   - No: Skip

3. **Do you need to debug complex code paths?**
   - Yes: Invest in DAP setup
   - No: Stick with print debugging

4. **Are you happy with your current keymap muscle memory?**
   - Yes: Don't reorganize keymaps
   - No/Neutral: Consider LazyVim conventions

5. **Is startup time a problem?**
   - Yes: Audit lazy-loading
   - No: Don't optimize prematurely

---

## Conclusion

Your Neovim config is already excellent and well-suited for Stripe development. LazyVim offers some nice-to-have improvements, but not a compelling reason to do a full migration.

**Best approach:** Cherry-pick 3-5 features from this document that solve specific pain points you experience.

**Respect your existing investment:** You've built sophisticated Stripe integrations that would be hard to replicate in LazyVim.

**Community alignment:** Adopting some LazyVim conventions (keymaps, structure) makes it easier for others to understand your config, but your custom approaches (fzf-lua, proximity sorting, Sourcegraph) are legitimate choices worth keeping.
