-- ============================================================================
-- Core Interface & Behavior (Neovim 0.11+)
-- ============================================================================
vim.opt.termguicolors = true      -- Enable 24-bit RGB color
vim.opt.background = "dark"
vim.opt.mouse = "a"               -- Allow mouse usage in all modes

-- Timing (Critical for Leader Key & Responsiveness)
vim.opt.timeoutlen = 500          -- Wait 500ms for mapped sequences (Leader key)
vim.opt.updatetime = 200          -- Faster diagnostics and swap file write

-- Line Numbers & Scrolling
vim.opt.number = true             -- Show absolute line numbers
vim.opt.relativenumber = true     -- Show relative line numbers for fast jumps
vim.opt.cursorline = true         -- Highlight the current line
vim.opt.scrolloff = 10            -- Keep cursor centered (10 lines of padding)
vim.opt.smoothscroll = true       -- Smooth scrolling for wrapped lines

-- Search Settings
vim.opt.ignorecase = true         -- Case-insensitive search
vim.opt.smartcase = true          -- Case-sensitive if capital letter is used
vim.opt.hlsearch = true           -- Highlight all search matches

-- ============================================================================
-- Indentation & Formatting (Treesitter-friendly)
-- ============================================================================
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true          -- Convert tabs to spaces
vim.opt.autoindent = true         -- Copy indent from current line when starting a new one
-- smartindent REMOVED: Treesitter handles complex indentation better natively

-- ============================================================================
-- System & File Persistence
-- ============================================================================
vim.opt.undofile = true           -- Save undo history to a file
vim.opt.swapfile = false
vim.opt.backup = false
if os.getenv("SSH_TTY") then
    -- Over SSH: use OSC 52 to copy to host clipboard through zellij
    local osc52 = require("vim.ui.clipboard.osc52")
    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = osc52.copy("+"),
            ["*"] = osc52.copy("*"),
        },
        paste = {
            ["+"] = osc52.paste("+"),
            ["*"] = osc52.paste("*"),
        },
    }
end
vim.opt.clipboard = "unnamedplus"

-- ============================================================================
-- UI Refinements
-- ============================================================================
vim.opt.signcolumn = "yes"        -- Always show signcolumn to prevent text shifting
vim.opt.laststatus = 3            -- Global statusline (one for all windows)
vim.opt.pumheight = 12            -- Pop-up menu height
vim.opt.splitright = true         -- Vertical splits open to the right
vim.opt.splitbelow = true         -- Horizontal splits open below

-- Visual Whitespace (Clean look)
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- Space characters REMOVED in favor of Snacks.indent lines

-- ============================================================================
-- Auto-commands (Modern Lua API)
-- ============================================================================
local augroup = vim.api.nvim_create_augroup("CustomSettings", { clear = true })

-- Trim trailing whitespace on save without moving the cursor
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = "*",
    callback = function()
        local save = vim.fn.winsaveview()
        vim.cmd([[keepjumps keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(save)
    end,
})

-- Highlight text on yank (copy) - very helpful feedback
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
    end,
})

-- Enable inlay hints when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(ev)
        vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end,
})
