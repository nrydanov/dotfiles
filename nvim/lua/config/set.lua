-- Enable true color support in the terminal
vim.opt.termguicolors = true

-- Show line numbers
vim.opt.nu = true

-- Highlight the current line where the cursor is
vim.opt.cursorline = true

-- Ignore case when searching
vim.opt.ignorecase = true

-- Highlight columns at position 80 and 100 for better readability (soft line limits)
vim.opt.colorcolumn = "80,100"

-- Set tab width to 4 spaces
vim.opt.tabstop = 4

-- Number of spaces inserted for a soft tab
vim.opt.softtabstop = 4

-- Number of spaces to use for each step of (auto)indent
vim.opt.shiftwidth = 4

-- Convert tabs to spaces
vim.opt.expandtab = true

vim.opt.autoindent = true

vim.opt.smartindent = true

-- Save undo history to a file to maintain it across sessions
vim.opt.undofile = true

-- Always show the sign column (e.g., for error signs) to avoid text shifting
vim.opt.signcolumn = "yes"

-- Configure completion options for longer matches and a pop-up menu with at least one item
vim.opt.completeopt = "longest,menuone"

-- Highlight matching brackets and parentheses when the cursor is over them
vim.opt.showmatch = true

-- Set a short delay for showing matching brackets/parentheses
vim.opt.mat = 2

-- Limit the height of the pop-up menu to 5 items
vim.opt.pumheight = 5

-- Enable syntax highlighting
vim.opt.syntax = "on"

-- Set background color to dark to improve contrast with color schemes
vim.opt.background = "dark"

-- Use the system clipboard for all yank, delete, change, and put operations
vim.opt.clipboard = "unnamedplus"

-- Show relative line numbers to help navigate quickly with line numbers
vim.opt.relativenumber = true

-- Disable relative line numbers when entering Insert mode
vim.cmd('autocmd InsertEnter * :set norelativenumber')

-- Re-enable relative line numbers when leaving Insert mode
vim.cmd('autocmd InsertLeave * :set relativenumber')

-- Automatically remove trailing whitespace before saving a file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})

-- Set the username for the "instant" plugin (or other related plugins that require a username)
vim.g.instant_username = "nrydanov"



vim.cmd('filetype plugin indent on')

