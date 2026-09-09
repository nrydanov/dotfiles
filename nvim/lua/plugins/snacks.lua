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
            -- Machine-local ~/.gitconfig may set diff.external (difftastic etc.);
            -- previews need plain git diff output so the "diff" filetype
            -- highlights it. Applies to every git previewer, not just status.
            previewers = { git = { args = { "-c", "diff.external=" } } },
            sources = {
                explorer = {
                    diagnostics = true,
                    git_status = true,
                    watch = true,
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
