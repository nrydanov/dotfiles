local M = {}

function M.assert_eq(actual, expected, message)
    if actual ~= expected then
        error((message or "assert_eq failed") .. "\nexpected: " .. vim.inspect(expected) .. "\nactual: " .. vim.inspect(actual), 2)
    end
end

function M.assert_truthy(value, message)
    if not value then
        error(message or "expected truthy value", 2)
    end
end

function M.assert_false(value, message)
    if value then
        error(message or "expected false/nil value", 2)
    end
end

function M.current_buf_overlay_extmarks()
    return vim.api.nvim_buf_get_extmarks(0, vim.api.nvim_create_namespace("structdiff_overlay"), 0, -1, { details = true })
end

function M.count_virtual_lines(extmarks)
    local count = 0
    for _, mark in ipairs(extmarks) do
        if mark[4] and mark[4].virt_lines then
            count = count + 1
        end
    end
    return count
end

return M
