return {
  "ms-jpq/coq_nvim",
  branch = "coq",
  dependencies = { "ms-jpq/coq.artifacts" },
  init = function()
    vim.g.coq_settings = {
      auto_start = 'shut-up',  -- тихий старт COQ, без лишних сообщений
      match = {
        look_ahead = 8,        -- стандартное значение, обеспечивающее хороший баланс
        exact_matches = 0,
      },
      weights = {
        prefix_matches = 1.5,
        edit_distance = 1.5,
      },
      display = {
        pum = {
          fast_close = false,  -- меню остается открытым до выбора
        },
      },
      completion = {
        skip_after = { "{", "}", "[", "]", "(", ")", "<", ">", "'", "\"", " ", ",", ";", ":", ".", "?", "!" },
      },
    }
  end,
  install = function()
    vim.cmd("COQdeps")
  end,
}
