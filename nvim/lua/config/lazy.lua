-- ============================================================================
-- Lazy.nvim Bootstrap Configuration
-- ============================================================================

-- Define the installation path for lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if not already installed
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

-- Prepend lazy.nvim to the runtime path
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
            enabled = true,    -- Включить кэширование для ускорения загрузки
        },
        reset_packpath = true, -- Сбросить packpath для чистоты
        rtp = {
            reset = true,      -- Сбросить runtime path
            paths = {},        -- Добавить дополнительные пути при необходимости
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
                "rplugin", -- Отключить remote plugins если не используете
                "synmenu",
                "optwin",
                "compiler",
                "bugreport",
                "ftplugin",
            },
        },
    },
})
