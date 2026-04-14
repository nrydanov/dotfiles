return {
    "nvim-treesitter/nvim-treesitter",
    branch = "*",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            auto_install = true,
        })
    end
}
