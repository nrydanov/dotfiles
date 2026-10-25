-- Nvim detects 'background' from the terminal (OSC 11) at startup and again
-- when the terminal reports a theme change (DEC mode 2031), so follow it.
local function apply()
    local name = vim.o.background == "light" and "onelight" or "onedark"
    if vim.g.colors_name ~= name and not pcall(vim.cmd.colorscheme, name) then
        vim.notify("Error setting up Neovim theme", vim.log.levels.ERROR)
    end
end

apply()
vim.api.nvim_create_autocmd("OptionSet", { pattern = "background", callback = apply })
