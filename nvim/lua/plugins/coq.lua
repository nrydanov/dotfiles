return {
    "ms-jpq/coq_nvim",
    branch = "coq",
    dependencies = { "ms-jpq/coq.artifacts" },
    init = function()
        vim.g.coq_settings = {
            auto_start = 'shut-up', -- if you want to start COQ at startup
            match = {
                look_ahead = 8,
                exact_matches = 0,
            },
            weights = {
                prefix_matches = 1.5,
                edit_distance = 1.5
            },
            display = {
                pum = {
                    fast_close = false
                }
            },
            completion = {
                skip_after = { "{", "}", "[", "]", "(", ")", "<", ">", "'", "\"", ' ', ',', ';', ':', '.', '?', '!' },
            }
            -- Your COQ settings here
        }
    end
}
