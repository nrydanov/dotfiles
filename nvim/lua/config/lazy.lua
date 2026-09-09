-- ============================================================================
-- Lazy.nvim Bootstrap Configuration
-- ============================================================================

-- Define the installation path for lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if not already installed
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

-- Prepend lazy.nvim to the runtime path.
-- lua_ls types `vim.opt.rtp` as its value type (string[]) rather than as
-- vim.Option, so it can't see the :prepend() method that exists at runtime.
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- ============================================================================
-- Lazy.nvim Setup
-- ============================================================================

require("lazy").setup({
    spec = {
        -- Import your plugin specifications.
        { import = "plugins" },
        -- Uncomment the next line to import additional modules (example for Rust):
        -- { import = "lazyvim.plugins.extras.lang.rust" },
    },
    defaults = {
        -- Load custom plugins during startup (set to true for lazy-loading custom plugins)
        lazy = false,
        -- Always use the latest commit instead of versioning; adjust as needed.
        version = nil,
    },
    ui = {
        border = "rounded", -- Use rounded borders in the Lazy.nvim UI
    },
    performance = {
        cache = {
            enabled = true,    -- Cache compiled Lua to speed up startup
        },
        reset_packpath = true, -- Drop the default packpath
        rtp = {
            reset = true,      -- Drop the default runtime path
            paths = {},        -- Extra runtime paths, if ever needed
            -- Only names that actually exist in $VIMRUNTIME/plugin belong here;
            -- anything else is silently ignored. Check with:
            --     :!ls $VIMRUNTIME/plugin
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "rplugin",
                "tarPlugin",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
