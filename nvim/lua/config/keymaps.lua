-- ============================================================================
-- Global Key Mappings
-- ============================================================================
-- File Explorer and Diagnostics
vim.keymap.set("n", "<space>d", ":NvimTreeToggle<CR>", { noremap = true, silent = true }) -- Toggle file explorer
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })

-- Custom motion mappings (ensure these overrides are intentional)
vim.keymap.set("n", "E", "$", { remap = true, silent = true }) -- Jump to end of line
vim.keymap.set("n", "S", "0", { remap = true, silent = true }) -- Jump to beginning of line

-- Terminal mode mapping to exit terminal insert mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- Other global mappings
vim.keymap.set("n", "<space>v", ":VenvSelect<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space>o", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space>l", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space>w", ":Telescope lsp_dynamic_workspace_symbols<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space>b", ":Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<space>t", ":Telescope diagnostics<CR>", { noremap = true, silent = true })

-- Remap 'I' to 'i' (override default behavior; review if this is desired)
vim.keymap.set("n", "I", "i", { noremap = true, silent = true })


-- ============================================================================
-- LSP-related (Buffer-Local) Mappings
-- ============================================================================
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Enable omni-completion (<c-x><c-o>)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf, noremap = true, silent = true }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set({ "n", "v" }, "<space>f", function()
            vim.lsp.buf.format({ async = true, remap = false })
        end, opts)
    end,
})


-- ============================================================================
-- Filetype-specific Settings
-- ============================================================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "cpp", "hpp", "c", "h" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
    end,
})
