local h = require("tests.helpers")

local M = {}

function M.test_space_d_has_no_longer_prefix_mappings()
    for _, map in ipairs(vim.api.nvim_get_keymap("n")) do
        h.assert_false(map.lhs:match("^<Space>d."), "<Space>d is delayed by longer mapping: " .. map.lhs)
    end
end

function M.test_structdiff_keymaps_exist()
    for _, lhs in ipairs({ "<Space>td", "<Space>tn", "<Space>tp", "<Space>tv", "<Space>tq" }) do
        h.assert_truthy(vim.fn.maparg(lhs, "n") ~= "", lhs .. " should be mapped")
    end
end

function M.test_space_td_is_structdiff_overlay()
    local map = vim.fn.maparg("<Space>td", "n", false, true)
    h.assert_truthy((map.desc or ""):lower():match("structural overlay"), "<Space>td should toggle StructDiff overlay")
end

return M
