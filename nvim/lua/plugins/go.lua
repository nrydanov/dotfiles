return {
    "ray-x/go.nvim",
    event = { "CmdlineEnter" },
    config = function()
        require("go").setup({
            goimports = "golines",
            gofmt = "gofumpt",
            lsp_cfg = true,
            lsp_inlay_hints = {
                enable = false,
            }
        })

        local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
                require('go.format').goimports()
            end,
            group = format_sync_grp,
        })
        vim.api.nvim_create_autocmd("LspAttach", {
            pattern = "*.go",
            callback = function(args)
                local bufnr = args.buf
                vim.keymap.set('n', '<space>f', function()
                    require('go.format').goimports()
                end, { buffer = bufnr, silent = true })
            end
        })
    end,
    ft = { "go", 'gomod' },
}
