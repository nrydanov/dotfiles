# StructDiff Gitsigns-like Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a local Neovim structural-diff module that feels like a small subset of gitsigns while using difftastic (`difft`) to render change previews.

**Architecture:** Keep gitsigns for stage/reset/blame and add `config.structdiff` for structural signs, navigation, refresh, and preview. The module uses `git diff --unified=0` only to locate changed line ranges and `difft --display inline` to render structural preview text for the current file/hunk. This keeps the MVP reliable without trying to apply structural hunks as patches.

**Tech Stack:** Neovim Lua, `git`, `difft` CLI, signs/extmarks, scratch floating windows.

**Spec:** Chat-approved MVP: gitsigns-like structural signs/navigation/preview without stage/reset.

## Global Constraints

- Do not replace gitsigns stage/reset/blame behavior.
- Do not depend on `andrewhwaller/difftastic.nvim` for core behavior.
- Must notify clearly for untracked files, unchanged files, missing git repo, missing `difft`, and command errors.
- Must keep `<leader>d` explorer fast by avoiding `<leader>d*` mappings.

---

### Task 1: StructDiff core module

**Files:**
- Create: `nvim/lua/config/structdiff.lua`
- Modify: `nvim/init.lua`
- Modify: `nvim/lua/plugins/difftastic.lua`
- Modify: `nvim/lua/plugins/which-key.lua`

**Interfaces:**
- Produces: `require("config.structdiff").setup(opts?)`
- Produces: `refresh(bufnr?)`, `next_hunk()`, `prev_hunk()`, `preview_hunk()`, `toggle_signs()`, `close_preview()`

- [ ] Step 1: Write RED headless checks for public API and commands.
- [ ] Step 2: Implement module with dependency checks and command registration.
- [ ] Step 3: Verify commands exist and missing-dependency paths notify instead of failing.
- [ ] Step 4: Commit or report diff.

### Task 2: Parse changed ranges and draw signs

**Files:**
- Modify: `nvim/lua/config/structdiff.lua`

**Interfaces:**
- Consumes: module state from Task 1.
- Produces internal `state[bufnr].hunks = { { start = number, finish = number, kind = string } }`.

- [ ] Step 1: Write RED parser checks with sample `git diff --unified=0` hunk headers.
- [ ] Step 2: Implement hunk parser and sign placement.
- [ ] Step 3: Verify signs are placed for modified tracked files.
- [ ] Step 4: Verify untracked and unchanged files notify clearly.

### Task 3: Navigation and preview

**Files:**
- Modify: `nvim/lua/config/structdiff.lua`

**Interfaces:**
- Consumes: `state[bufnr].hunks`.
- Produces: `next_hunk()`, `prev_hunk()`, `preview_hunk()`.

- [ ] Step 1: Write RED headless checks for hunk selection around cursor.
- [ ] Step 2: Implement next/prev navigation with wrap.
- [ ] Step 3: Implement floating preview using `difft --display inline --color never` for temp old/new files.
- [ ] Step 4: Verify preview opens for a modified tracked file and closes cleanly.

### Task 4: Autocommands and keymaps

**Files:**
- Modify: `nvim/lua/config/structdiff.lua`
- Modify: `nvim/init.lua`
- Modify: `nvim/lua/plugins/difftastic.lua`
- Modify: `nvim/lua/plugins/which-key.lua`

**Interfaces:**
- Consumes: all public functions.
- Produces user UX mappings: `<leader>td`, `<leader>tn`, `<leader>tp`, `<leader>tv`, `<leader>tq`.

- [ ] Step 1: Register autocommands for `BufEnter`, `BufWritePost`, `TextChanged`, and `TextChangedI` with debounce.
- [ ] Step 2: Map keys and update which-key descriptions.
- [ ] Step 3: Disable external `difftastic.nvim` plugin to avoid conflicting UX.
- [ ] Step 4: Run headless verification and manual smoke commands.
