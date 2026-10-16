return {
    "lewis6991/gitsigns.nvim",
    version = "*",
    opts = {
        diff_opts = {
            internal = true,
            ignore_whitespace = true,
            ignore_blank_lines = true,
            linematch = 60,
        },
        current_line_blame = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 0,
            ignore_whitespace = false,
            virt_text_priority = 100,
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end
            --- Navigation (structural marks take over while MR review is on)
            local function nav(dir)
                local sd = require("mrview.structdiff")
                if sd.active() then sd.nav(dir) else gs.nav_hunk(dir) end
            end
            map('n', ']g', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() nav('next') end)
                return '<Ignore>'
            end, { expr = true })

            map('n', '[g', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() nav('prev') end)
                return '<Ignore>'
            end, { expr = true })

            -- Actions
            map('n', '<leader>hs', gs.stage_hunk, { desc = "stage hunk" })
            map('n', '<leader>hr', gs.reset_hunk, { desc = "reset hunk" })
            map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                { desc = "stage hunk" })
            map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                { desc = "reset hunk" })
            map('n', '<leader>hS', gs.stage_buffer, { desc = "stage buffer" })
            map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "undo stage hunk" })
            map('n', '<leader>hR', gs.reset_buffer, { desc = "reset buffer" })
            map('n', '<leader>hp', gs.preview_hunk, { desc = "preview hunk" })
            map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "blame hunk" })
            map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "blame line" })
            map('n', '<leader>hd', gs.diffthis, { desc = "diff against index" })
            map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "diff against last commit" })
            map('n', '<leader>td', function()
                local sd = require("mrview.structdiff")
                if sd.active() then sd.toggle_deleted() else gs.toggle_deleted() end
            end, { desc = "deleted lines" })
            map('n', '<leader>ts', function()
                local sd = require("mrview.structdiff")
                if sd.active() then sd.toggle_split() end
            end, { desc = "side-by-side base pane" })
        end
    }
}
