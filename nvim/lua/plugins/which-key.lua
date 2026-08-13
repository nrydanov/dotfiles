return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        icons = { mappings = false },
        spec = {
            { "<leader>h",  group = "git hunks" },
            { "<leader>t",  group = "toggle" },
            { "<leader>tb", desc = "blame line" },
            { "<leader>td", desc = "toggle structural overlay" },
            { "<leader>tn", desc = "next structural change" },
            { "<leader>tp", desc = "previous structural change" },
            { "<leader>tv", desc = "toggle structural signs" },
            { "<leader>tq", desc = "close structural diff preview" },
            { "<leader>r",  group = "refactor" },
            { "<leader>c",  group = "code" },
        },
    },
}
