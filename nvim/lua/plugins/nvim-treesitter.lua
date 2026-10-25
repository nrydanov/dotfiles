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

        -- The main branch only installs parsers; highlighting is started
        -- per buffer. Files without a parser keep the legacy syntax.
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
            callback = function(ev)
                pcall(vim.treesitter.start, ev.buf)
            end,
        })
    end
}
