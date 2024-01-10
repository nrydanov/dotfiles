require 'plugins'
require 'remap'
require 'set'

vim.api.nvim_create_autocmd("Filetype", {
    pattern = "sql",
    callback = function() 
        vim.keymap.del('i','<left>',{buffer = true})
        vim.keymap.del('i','<right>',{buffer = true})
    end
})
