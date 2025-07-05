return {
    "ms-jpq/coq_nvim",
    branch = "coq",
    init = function()
        vim.g.coq_settings = {
            auto_start = 'shut-up',
            match = { fuzzy_cutoff = 0.8, max_results = 3 },
            weights = { prefix_matches = 3 },
            display = { pum = { fast_close = false } },
            completion = {
                skip_after = { "{", "}", "(", ")", "<", ">", "'", "\"", " ", ",", ";", ":", "?", "!" },
            },
            clients = {
                snippets = { enabled = false },
                buffers = { enabled = false }
            },
            keymap = {
                manual_complete = 'c-l',
            }
        }
    end
}
