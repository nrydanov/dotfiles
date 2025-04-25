-- ============================================================================
-- General Appearance & Behavior
-- ============================================================================
vim.opt.termguicolors = true -- Enable true color support
vim.opt.background = "dark"  -- Use a dark background for better contrast
vim.opt.syntax = "on"        -- Enable syntax highlighting

-- ============================================================================
-- Line Numbers & Cursor
-- ============================================================================
vim.opt.nu = true             -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true     -- Highlight the current line

-- Autocmds to toggle relative numbers when entering/leaving Insert mode
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    callback = function() vim.opt.relativenumber = false end,
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    callback = function() vim.opt.relativenumber = true end,
})

-- ============================================================================
-- Search Settings
-- ============================================================================
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true  -- Override ignorecase if uppercase is used
vim.opt.incsearch = true  -- Show incremental search results

-- ============================================================================
-- Indentation & Tabs
-- ============================================================================
vim.opt.tabstop = 4        -- Number of spaces that a tab counts for
vim.opt.softtabstop = 4    -- Number of spaces inserted for a soft tab
vim.opt.shiftwidth = 4     -- Spaces per indentation level
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.autoindent = true  -- Maintain indentation from previous line
vim.opt.smartindent = true -- Insert indents automatically in some cases

-- ============================================================================
-- Undo, Swap & Backup Files
-- ============================================================================
vim.opt.undofile = true  -- Persist undo history across sessions
vim.opt.swapfile = false -- Disable swap files to avoid clutter
vim.opt.backup = false   -- Disable backup files if using version control

-- ============================================================================
-- Editor UI Extras
-- ============================================================================
vim.opt.signcolumn = "yes"               -- Always show the sign column to avoid shifting
vim.opt.completeopt = "menuone,noselect" -- Better completion: show menu even for one item and don't auto-select
vim.opt.showmatch = true                 -- Highlight matching parentheses and brackets
vim.opt.mat = 2                          -- Short delay (in tenths of a second) for matching bracket highlighting
vim.opt.pumheight = 5                    -- Limit pop-up menu height to 5 items

-- Highlight soft line limits for readability
vim.opt.colorcolumn = "80,100"

-- ============================================================================
-- Clipboard & Filetype Settings
-- ============================================================================
vim.opt.clipboard = "unnamedplus"    -- Use system clipboard for yank, delete, change, and put
vim.cmd('filetype plugin indent on') -- Enable filetype detection, plugins, and indenting

-- ============================================================================
-- Auto Commands
-- ============================================================================
-- Automatically remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- ============================================================================
-- Plugin-Specific Settings
-- ============================================================================
vim.g.instant_username = "nrydanov" -- Set username for the "instant" plugin (if used)


-- ============================================================================
-- File Backup, Swap, and Undo Settings
-- ============================================================================
vim.opt.backup = false      -- Disable backup files (if using version control)
vim.opt.writebackup = false -- Disable backup before overwriting files
vim.opt.swapfile = false    -- Disable swap files (adjust if needed)
vim.opt.undofile = true     -- Enable persistent undo
vim.diagnostic.config({
    virtual_text = true,

})
