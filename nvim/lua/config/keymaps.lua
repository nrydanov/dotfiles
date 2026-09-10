vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- ============================================================================
-- Global Key Mappings
-- ============================================================================
-- File Explorer and Diagnostics
vim.keymap.set("n", "<leader>d", function() Snacks.explorer() end, { desc = "Toggle Explorer" })
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gh", function()
    -- cmd_args land after the `diff` subcommand, so this is `git diff -- <file>`
    Snacks.picker.git_diff({ cmd_args = { "--", vim.api.nvim_buf_get_name(0) } })
end, { desc = "Git hunks (current file)" })
vim.keymap.set("n", "<leader>gH", function() Snacks.picker.git_diff() end, { desc = "Git hunks (all files)" })
vim.keymap.set("n", "<leader>gm", function() require("config.mr_review").on() end, { desc = "MR review on" })
vim.keymap.set("n", "<leader>gd", function() require("config.mr_review").on_structural() end,
    { desc = "MR review on (structural)" })
vim.keymap.set("n", "<leader>gM", function() require("config.mr_review").off() end, { desc = "MR review off" })
vim.keymap.set("n", "<leader>gb", function() require("config.mr_review").set_base() end, { desc = "MR review base" })
vim.keymap.set("n", "<leader>gf", function() require("config.mr_review").files() end, { desc = "MR changed files" })
vim.keymap.set("n", "<leader>gv", function() require("config.mr_review").toggle_reviewed() end,
    { desc = "MR toggle reviewed" })
vim.keymap.set("n", "<leader>gV", function() require("config.mr_review").since_review() end,
    { desc = "MR diff since review" })
vim.keymap.set({ "n", "v" }, "<leader>gc", function() require("config.mr_comment").add() end,
    { desc = "MR comment on line/range" })
vim.keymap.set("n", "<leader>gC", function() require("config.mr_comment").pick() end,
    { desc = "MR pending comments" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { noremap = true, silent = true })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { noremap = true, silent = true })

-- Custom motion mappings (ensure these overrides are intentional)
vim.keymap.set("n", "E", "$", { remap = true, silent = true }) -- Jump to end of line
vim.keymap.set("n", "S", "0", { remap = true, silent = true }) -- Jump to beginning of line

-- Terminal mode mapping to exit terminal insert mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- Other global mappings
vim.keymap.set("n", "<leader>o", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>re", function() Snacks.picker.resume() end, { desc = "Resume picking" })
vim.keymap.set("n", "<leader>l", function() Snacks.picker.grep({ regex = true }) end, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>w", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Workspace Symbols" })
vim.keymap.set("n", "<leader>b", function() Snacks.picker.buffers() end, { desc = "Find Buffers" })
vim.keymap.set("n", "<leader>m", function() Snacks.picker.marks() end, { desc = "Find Marks" })
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go to Definition" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references({ regex = true }) end, { desc = "LSP References" })
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions({ regex = true }) end,
    { desc = "LSP Type Definitions" })
vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations({ regex = true }) end, { desc = "LSP Implementations" })
vim.keymap.set("n", "<leader>x", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })

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
