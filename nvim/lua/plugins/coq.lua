return {
    "ms-jpq/coq_nvim",
    branch = "coq",
    dependencies = { "ms-jpq/coq.artifacts" },
    init = function()
        vim.g.coq_settings = {
            auto_start = 'shut-up', -- тихий старт COQ, без лишних сообщений
            match = {
                fuzzy_cutoff = 0.8
            },
            weights = {
                prefix_matches = 3,
            },
            display = {
                pum = {
                    fast_close = false, -- меню остается открытым до выбора
                },
            },
            completion = {
                skip_after = { "{", "}", "(", ")", "<", ">", "'", "\"", " ", ",", ";", ":", "?", "!" },
            },
            clients = {
                snippets = {
                    enabled = false
                }
            }
        }
    end,
    install = function()
        vim.cmd("COQdeps")
    end,
}
