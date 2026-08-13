local parsers = {
    "bash",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "query",
    "rust",
    "toml",
    "vim",
    "vimdoc",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function()
        require("nvim-treesitter").install(parsers, { force = true }):wait(300000)
    end,
    config = function()
        local treesitter = require("nvim-treesitter")

        treesitter.setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        treesitter.install(parsers)
    end
}
