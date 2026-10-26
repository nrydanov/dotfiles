return {
    "nrydanov/incognito.nvim",
    dependencies = { "lewis6991/gitsigns.nvim", "folke/snacks.nvim" },
    cmd = "Incognito",
    opts = {},
    keys = {
        { "<leader>gm", function() require("incognito").on() end, desc = "MR review on" },
        { "<leader>gd", function() require("incognito").structural() end, desc = "MR review on (structural)" },
        { "<leader>gM", function() require("incognito").off() end, desc = "MR review off" },
        { "<leader>gb", function() require("incognito").base() end, desc = "MR review base" },
        { "<leader>gf", function() require("incognito").files() end, desc = "MR changed files" },
        { "<leader>gk", function() require("incognito").commits() end, desc = "MR commits" },
        { "]C", function() require("incognito").next_commit() end, desc = "MR next commit" },
        { "[C", function() require("incognito").prev_commit() end, desc = "MR previous commit" },
        { "<leader>gv", function() require("incognito").toggle_reviewed() end, desc = "MR toggle reviewed" },
        { "<leader>gV", function() require("incognito").since_review() end, desc = "MR diff since review" },
    },
}
