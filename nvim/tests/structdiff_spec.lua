local h = require("tests.helpers")
local sd = require("config.structdiff")

local M = {}

local function scratch(lines)
    vim.cmd("enew!")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.buftype = "nofile"
end

function M.test_public_api_exists()
    for _, name in ipairs({
        "setup",
        "refresh",
        "next_hunk",
        "prev_hunk",
        "preview_hunk",
        "toggle_overlay",
        "show_overlay",
        "clear_overlay",
        "toggle_signs",
        "close_preview",
    }) do
        h.assert_eq(type(sd[name]), "function", name .. " should be a function")
    end
end

function M.test_difftastic_parser_preserves_leading_spaces()
    local out = "\27[91;1m2 \27[0m   \27[91;1m        removed();\27[0m\n"
        .. "   \27[92;1m3 \27[0m\27[92m        added();\27[0m"
    local parsed = sd._parse_difftastic_overlay(out)

    h.assert_eq(parsed.deletions[1].content, "        removed();", "deleted content should keep indentation")

    local added = ""
    for _, segment in ipairs(parsed.additions[1].segments) do
        added = added .. segment[1]
    end
    h.assert_eq(added, "        added();", "added content should keep indentation")
end

function M.test_additions_do_not_render_duplicate_overlay_lines_or_highlights()
    scratch({
        "fn should_skip_ttl(header: &KeyHeader, min_ttl: Duration) -> bool {",
        "    header",
        "        .expire_at",
        "        .is_some_and(|t| t < std::time::SystemTime::now() + min_ttl)",
        "}",
    })

    local changes = {
        additions = {
            {
                line_num = 4,
                segments = {
                    { "        .is_some_and(|t| t < std::time::SystemTime::now() + min_ttl)", "StructDiffAddToken" },
                },
            },
        },
        modifications = {},
        deletions = {},
    }

    local marks = sd._render_overlay_changes(0, changes)
    h.assert_eq(#marks, 0, "pure additions should rely on signs and must not duplicate/highlight existing code")
end

function M.test_deletions_render_virtual_lines_with_indentation()
    scratch({
        "fn main() {",
        "    kept();",
        "}",
    })

    local changes = {
        additions = {},
        modifications = {},
        deletions = {
            { line_num = 2, content = "        removed();" },
        },
    }

    local marks = sd._render_overlay_changes(0, changes)
    h.assert_eq(h.count_virtual_lines(marks), 1, "deletions should render as virtual lines")
    local virt = marks[1][4].virt_lines[1][1][1]
    h.assert_eq(virt, "  -         removed();", "deleted virtual line should preserve source indentation")
end

function M.test_modifications_render_inline_highlights_without_opening_windows()
    scratch({ "let value = new_value;" })
    local wins_before = #vim.api.nvim_list_wins()
    local changes = {
        additions = {},
        modifications = {
            { line_num = 1, segments = { { "let value = ", "Normal" }, { "new_value", "StructDiffAddToken" }, { ";", "Normal" } } },
        },
        deletions = {},
    }

    local marks = sd._render_overlay_changes(0, changes)
    h.assert_eq(#vim.api.nvim_list_wins(), wins_before, "overlay rendering should not open windows")
    h.assert_truthy(#marks > 0, "modification overlay should create inline extmarks")
    h.assert_eq(h.count_virtual_lines(marks), 0, "modifications should not render virtual duplicate lines")
end

return M
