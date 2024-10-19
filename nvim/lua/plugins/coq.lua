return {
    "ms-jpq/coq_nvim",
    branch = "coq",
    dependencies = { "ms-jpq/coq.artifacts" },
    init = function()
        vim.g.coq_settings = {
            auto_start = 'shut-up', -- if you want to start COQ at startup
            match = {
                fuzzy_cutoff = 0.2,
                look_ahead = 8,
                exact_matches = 0,
            },
            weights = {
                prefix_matches = 1.0,
                edit_distance = 2.0
            }
            -- Your COQ settings here
        }
    end
}
