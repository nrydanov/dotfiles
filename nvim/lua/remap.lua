vim.keymap.set("n", "<space>d", ":NvimTreeToggle<CR>") -- toggle file explorer
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', 'E', "$", { remap = true })
vim.keymap.set('n', 'S', "0", { remap = true })
vim.api.nvim_set_keymap("n", "<space>v", ":VenvSelect<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<space>o', ':Telescope find_files<CR>',
    {
        silent = true
    })
vim.api.nvim_set_keymap('n', '<space>l', ':Telescope live_grep<CR>',
    {
        silent = true
    })
vim.api.nvim_set_keymap('n', '<space>w', ':Telescope lsp_dynamic_workspace_symbols<CR>',
    {
        silent = true
    })
vim.api.nvim_set_keymap('n', 'gd', ':Telescope lsp_definitions<CR>',
    {
        silent = true
    })
vim.api.nvim_set_keymap('n', 'gr', ':Telescope lsp_references<CR>',
    {
        silent = true
    })

vim.api.nvim_set_keymap('n', '<space>e', ':Telescope diagnostics<CR>',
    {
        silent = true
    })


vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>f', function()
            vim.lsp.buf.format { async = true, remap = false }
        end, opts)
    end,
})
