-- below is the default configuration, there's no need to copy paste them if
-- you are satisfied with the default configuration, just calling
-- `require('yarepl').setup {}` is sufficient.
local yarepl = require 'yarepl'

yarepl.setup {
    -- see `:h buflisted`, whether the REPL buffer should be buflisted.
    buflisted = true,
    -- whether the REPL buffer should be a scratch buffer.
    scratch = true,
    -- the filetype of the REPL buffer created by `yarepl`
    ft = 'REPL',
    -- How yarepl open the REPL window, can be a string or a lua function.
    -- See below example for how to configure this option
    wincmd = 'vert belowright 45 split',
    -- The available REPL palattes that `yarepl` can create REPL based on
    metas = {
        ipython = { cmd = 'ipython', formatter = yarepl.formatter.bracketed_pasting },
        sml = { cmd = 'rlwrap sml', formatter = yarepl.formatter.bracketed_pasting }
    },
    -- when a REPL process exits, should the window associated with those REPLs closed?
    close_on_exit = true,
    -- whether automatically scroll to the bottom of the REPL window after sending
    -- text? This feature would be helpful if you want to ensure that your view
    -- stays updated with the latest REPL output.
    scroll_to_bottom_after_sending = true,
    os = {
        -- Some hacks for Windows. macOS and Linux users can simply ignore
        -- them. The default options are recommended for Windows user.
        windows = {
            -- Send a final `\r` to the REPL with delay,
            send_delayed_cr_after_sending = true,
        },
    },
}

local bufmap = vim.api.nvim_buf_set_keymap


local ft_to_repl = {
    python = 'ipython',
    sml = "sml"
}

local eval_functions = {
    sml = 'use \"%s\";'
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'python', 'sml' },
    group = vim.api.nvim_create_augroup("ReplConfig", {}),
    desc = 'set up REPL keymap',
    callback = function()
        local repl = ft_to_repl[vim.bo.filetype]
        repl = repl and ('-' .. repl) or ''

        bufmap(0, 'n', '<LocalLeader>rs', string.format('<Plug>(REPLStart%s)', repl), {
            desc = 'Start an REPL',
        })
        bufmap(0, 'n', '<LocalLeader>rf', '<Plug>(REPLFocus)', {
            desc = 'Focus on REPL',
        })
        -- bufmap(0, 'n', '<LocalLeader>rv', '<CMD>Telescope REPLShow<CR>', {
        --     desc = 'View REPLs in telescope',
        -- })
        bufmap(0, 'n', '<LocalLeader>rh', '<Plug>(REPLHide)', {
            desc = 'Hide REPL',
        })
        bufmap(0, 'v', '<LocalLeader>s', '<Plug>(REPLSendVisual)', {
            desc = 'Send visual region to REPL',
        })
        bufmap(0, 'n', '<LocalLeader>ss', '<Plug>(REPLSendLine)', {
            desc = 'Send line to REPL',
        })
        bufmap(0, 'n', '<LocalLeader>s', '<Plug>(REPLSendOperator)', {
            desc = 'Send current line to REPL',
        })
        bufmap(0, 'n', '<LocalLeader>re', '<Plug>(REPLExec)', {
            desc = 'Execute command in REPL',
            expr = true,
        })
        bufmap(0, 'n', '<LocalLeader>rq', '<Plug>(REPLClose)', {
            desc = 'Quit REPL',
        })
        bufmap(0, 'n', '<LocalLeader>rc', '<CMD>REPLCleanup<CR>', {
            desc = 'Clear REPLs.',
        })
        bufmap(0, 'n', '<LocalLeader>rS', '<CMD>REPLSwap<CR>', {
            desc = 'Swap REPLs.',
        })
        bufmap(0, 'n', '<LocalLeader>r?', '<Plug>(REPLStart)', {
            desc = 'Start an REPL from available REPL metas',
        })
        bufmap(0, 'n', '<LocalLeader>ra', '<CMD>REPLAttachBufferToREPL<CR>', {
            desc = 'Attach current buffer to a REPL',
        })
        bufmap(0, 'n', '<LocalLeader>rd', '<CMD>REPLDetachBufferToREPL<CR>', {
            desc = 'Detach current buffer to any REPL',
        })
        bufmap(0, 'n', '<LocalLeader>rx',
            string.format(string.format("<CMD>REPLExec %s<CR>", eval_functions[vim.bo.filetype]),
                vim.fn.expand("%:.")), {})
    end,
})
