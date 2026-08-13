local h = require("tests.helpers")

local M = {}

function M.test_nvim_treesitter_loads()
    local ok, mod = pcall(require, "nvim-treesitter")
    h.assert_truthy(ok, "nvim-treesitter should load")
    h.assert_eq(type(mod.install), "function", "nvim-treesitter.install should exist")
end

function M.test_configured_parser_revision_metadata_exists()
    for _, lang in ipairs({ "bash", "json", "lua", "markdown", "markdown_inline", "query", "rust", "toml", "vim", "vimdoc" }) do
        local path = vim.fn.stdpath("data") .. "/site/parser-info/" .. lang .. ".revision"
        h.assert_eq(vim.fn.filereadable(path), 1, "missing parser revision metadata for " .. lang)
    end
end

return M
