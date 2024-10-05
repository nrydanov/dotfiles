require('telescope').setup {
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {
            preview_cutoff = 40,
            horizontal = { preview_width = 0.5 },
            vertical = { width=0.7 }
            -- other layout configuration here
        },
        preview = {
            wrap = true,
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim" -- add this value
        }
        -- other defaults configuration here
    },
}
