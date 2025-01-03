-- Dark
vim.cmd.colorscheme('one-nvim')
-- Light
-- vim.cmd.colorscheme('onehalflight')
-- Comments next line if you generate config for Kitty
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

-- NOTE(nrydanov) Temporary treesitter fix
vim.api.nvim_set_hl(0, "@variable", { fg = "#e5c07b" })
