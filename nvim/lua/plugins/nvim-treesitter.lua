return {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup {
            ensure_installed = { "rust", "lua", "python" },
            highlight = { enable = true, disable = { 'html' } },
            indent = { enable = true },
            auto_install = true,
        }
    end
}
