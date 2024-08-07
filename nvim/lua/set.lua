vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.colorcolumn = "80,100"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.completeopt = "longest,menuone"
vim.opt.showmatch = true
vim.opt.mat = 2
vim.opt.pumheight = 5
vim.opt.syntax = "on"
vim.opt.background = "dark"
vim.opt.clipboard = "unnamedplus"
vim.opt.relativenumber = true
vim.cmd('autocmd VimLeave * set guicursor=a:ver25-blinkon10')
vim.cmd('autocmd InsertEnter * :set norelativenumber')
vim.cmd('autocmd InsertLeave * :set relativenumber')

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})
