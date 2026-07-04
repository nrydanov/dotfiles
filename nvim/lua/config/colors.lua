local mode = (vim.env.COLOR_MODE or ""):lower()

local ok
if mode == "light" then
  vim.o.background = "light"
  ok = pcall(vim.cmd.colorscheme, "onelight")
else
  vim.o.background = "dark"
  ok = pcall(vim.cmd.colorscheme, "onedark")
end
if not ok then
  vim.notify("Error setting up Neovim theme", vim.log.levels.ERROR)
end
