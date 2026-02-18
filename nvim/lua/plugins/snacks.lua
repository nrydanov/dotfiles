return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = true },
        indent = {
            enabled = true,
            char = "│",
            scope = {
                enabled = true,
                char = "│",
                underline = false,
            },
            chunk = {
                enabled = true,
            },
        },
        input = { enabled = true },
        picker = {
            sources = {
                explorer = {
                    jump = {
                        close = true,
                    },
                    layout = {
                        preset = "default",
                    },
                },
            },
        },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
}
