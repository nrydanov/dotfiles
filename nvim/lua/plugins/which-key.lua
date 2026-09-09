return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        icons = { mappings = false },
        spec = {
            { "<leader>g", group = "git" },
            { "<leader>h", group = "hunks" },
            { "<leader>t", group = "toggle" },
            { "<leader>r", group = "refactor" },
            { "<leader>c", group = "code" },
        },
    },
}
