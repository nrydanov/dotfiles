return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        icons = { mappings = false },
        spec = {
            { "<leader>h",  group = "git hunks" },
            { "<leader>t",  group = "toggle" },
            { "<leader>tb", desc = "blame line" },
            { "<leader>td", desc = "deleted lines" },
            { "<leader>r",  group = "refactor" },
            { "<leader>c",  group = "code" },
        },
    },
}
