return {
  "andrewhwaller/difftastic.nvim",
  config = function()
    require("difftastic-nvim").setup({
      target_branch = "main",  -- Branch to diff against (default: "main")
    })
  end,
  keys = {
    { "<leader>dt", "<cmd>DifftasticToggle<cr>", desc = "Toggle Difftastic Overlay" },
    { "<leader>ds", "<cmd>DifftasticSplit<cr>", desc = "Difftastic Split View" },
  },
}
