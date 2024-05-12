require "nvim-treesitter.configs".setup {
    ensure_installed = { 'rust', 'lua', 'python' },
    highlight = { enable = true },
    indent = { enable = true },
    auto_install = true,
}
