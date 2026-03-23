vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- ============================================================================
-- Global Key Mappings
-- ============================================================================
-- File Explorer and Diagnostics
vim.keymap.set("n", "<leader>d", function() Snacks.explorer() end, { desc = "Toggle Explorer" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })

-- Custom motion mappings (ensure these overrides are intentional)
vim.keymap.set("n", "E", "$", { remap = true, silent = true }) -- Jump to end of line
vim.keymap.set("n", "S", "0", { remap = true, silent = true }) -- Jump to beginning of line

-- Terminal mode mapping to exit terminal insert mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- Other global mappings
vim.keymap.set("n", "<leader>o", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>l", function() Snacks.picker.grep({ regex = true }) end, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>w", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>b", function() Snacks.picker.buffers() end, { desc = "Find Buffers" })
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go to Definition" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references({ regex = true }) end, { desc = "LSP References" })
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions({ regex = true }) end, { desc = "LSP References" })
vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations({ regex = true }) end, { desc = "LSP References" })
vim.keymap.set("n", "<leader>t", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })

-- Remap 'I' to 'i' (override default behavior; review if this is desired)
vim.keymap.set("n", "I", "i", { noremap = true, silent = true })


-- ============================================================================
-- LSP-related (Buffer-Local) Mappings
-- ============================================================================
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        -- Signature Help
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help,
            { buffer = ev.buf, desc = "LSP: Signature Help" })

        -- Rename
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
            { buffer = ev.buf, desc = "LSP: Rename" })

        -- Code Actions (using Snacks picker)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
            { buffer = ev.buf, desc = "LSP: Code Actions" })

        -- Format
        vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, { buffer = ev.buf, desc = "LSP: Format File" })
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
