local h = require("tests.helpers")
local sd = require("config.structdiff")

local M = {}

local RUST_ONE_LINE = [[
struct Config { name: String, retries: u32 }

fn build(name: &str, retries: u32) -> Config {
    Config { name: name.to_string(), retries }
}

fn main() {
    let cfg = build("picodata", 3);
}
]]

-- rustfmt layout of RUST_ONE_LINE. Trailing commas after the last field are
-- new tokens, so the struct literal on line 12 is a legitimate change.
local RUST_REFLOWED = [[
struct Config {
    name: String,
    retries: u32,
}

fn build(
    name: &str,
    retries: u32,
) -> Config {
    Config {
        name: name.to_string(),
        retries,
    }
}

fn main() {
    let cfg = build("picodata", 3);
}
]]

function M.test_reflow_only_gives_dim_marks_and_no_bright_ones()
    local dir = h.repo({ ["src/main.rs"] = RUST_ONE_LINE })
    h.write(dir, "src/main.rs", RUST_REFLOWED)
    local bufnr = h.open(dir, "src/main.rs")

    local signs = h.marks(bufnr)
    local bright = {}
    for lnum, kind in pairs(signs) do
        if kind ~= "Format" then
            bright[#bright + 1] = lnum
        end
    end
    h.assert_eq(bright, { 12 }, "only the trailing comma line is semantic")
    h.assert_eq(signs[1], "Format", "reflowed struct header is formatting only")
    h.assert_eq(signs[6], "Format", "reflowed fn signature is formatting only")
    h.assert_eq(signs[16], nil, "untouched line has no mark")
end

function M.test_real_change_inside_reflow_is_bright_with_inline_range()
    local dir = h.repo({ ["src/main.rs"] = RUST_ONE_LINE })
    h.write(dir, "src/main.rs", RUST_REFLOWED:gsub('build%("picodata", 3%)', 'build("picodata", 7)'))
    local bufnr = h.open(dir, "src/main.rs")

    local signs, inline = h.marks(bufnr)
    h.assert_eq(signs[17], "Change")
    h.assert_eq(inline[#inline], { 17, 32, 33 }, "inline mark covers exactly the `7`")
end

function M.test_unicode_inline_columns_are_bytes()
    local dir = h.repo({ ["a.lua"] = 'local x = "ü"\n' })
    h.write(dir, "a.lua", 'local x = "ü" .. "я"\n')
    local bufnr = h.open(dir, "a.lua")

    local _, inline = h.marks(bufnr)
    local text = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
    local last = inline[#inline]
    h.assert_eq(text:sub(last[2] + 1, last[3]), '"я"', "byte range lands on the added literal")
end

function M.test_new_file_marks_every_line_as_added()
    local dir = h.repo({ ["keep.txt"] = "x\n" })
    h.write(dir, "fresh.lua", "local a = 1\nlocal b = 2\n")
    local bufnr = h.open(dir, "fresh.lua")

    h.assert_eq(h.marks(bufnr), { "Add", "Add" })
end

function M.test_unchanged_file_has_no_marks()
    local dir = h.repo({ ["a.lua"] = "local a = 1\n" })
    local bufnr = h.open(dir, "a.lua")
    h.assert_eq(h.marks(bufnr), {})
end

function M.test_whitespace_only_change_is_format()
    local dir = h.repo({ ["a.lua"] = "local a = 1\nlocal b = 2\n" })
    h.write(dir, "a.lua", "local a  =  1\n\n\nlocal b = 2\n")
    local bufnr = h.open(dir, "a.lua")
    h.assert_eq(h.marks(bufnr), { "Format", "Format", "Format" })
end

function M.test_deletion_shows_virtual_line_above_anchor()
    local dir = h.repo({ ["a.lua"] = "local a = 1\nlocal b = 2\nlocal c = 3\n" })
    h.write(dir, "a.lua", "local a = 1\nlocal c = 3\n")
    local bufnr = h.open(dir, "a.lua")

    local signs, _, virt = h.marks(bufnr)
    h.assert_eq(virt, { [2] = { above = true, text = { "local b = 2" } } })
    h.assert_eq(signs, { [2] = "Delete" }, "anchor line gets the delete sign")
    h.assert_eq(h.marks(bufnr) and sd.nav("next") or vim.api.nvim_win_get_cursor(0)[1], 2, "]g stops on the anchor")
end

function M.test_deletion_at_end_of_file_renders_below_last_line()
    local dir = h.repo({ ["a.lua"] = "local a = 1\nlocal b = 2\nlocal c = 3\n" })
    h.write(dir, "a.lua", "local a = 1\n")
    local bufnr = h.open(dir, "a.lua")

    local signs, _, virt = h.marks(bufnr)
    h.assert_eq(virt, { [1] = { above = false, text = { "local b = 2", "local c = 3" } } })
    h.assert_eq(signs, { [1] = "Delete" })
end

function M.test_deletion_next_to_change_keeps_bright_sign()
    local dir = h.repo({ ["a.lua"] = "local a = 1\nlocal b = 2\nlocal c = 3\n" })
    h.write(dir, "a.lua", "local a = 1\nlocal c = 9\n")
    local bufnr = h.open(dir, "a.lua")

    local signs, _, virt = h.marks(bufnr)
    h.assert_eq(virt[2].text, { "local b = 2" })
    h.assert_eq(signs[2], "Change", "change sign wins over the delete sign on the same line")
end

function M.test_deleting_everything_shows_all_lines_below()
    local dir = h.repo({ ["a.lua"] = "local a = 1\nlocal b = 2\n" })
    h.write(dir, "a.lua", "")
    local bufnr = h.open(dir, "a.lua")

    local _, _, virt = h.marks(bufnr)
    h.assert_eq(virt[1].text, { "local a = 1", "local b = 2" })
end

function M.test_unknown_language_falls_back_to_text_diff()
    local dir = h.repo({ ["notes.xyz"] = "alpha\nbeta\n" })
    h.write(dir, "notes.xyz", "alpha\ngamma\n")
    local bufnr = h.open(dir, "notes.xyz")
    local signs = h.marks(bufnr)
    h.assert_eq(signs[2], "Change", "difft text mode still yields a change")
end

function M.test_comment_change_is_semantic()
    local dir = h.repo({ ["a.lua"] = "-- old note\nlocal a = 1\n" })
    h.write(dir, "a.lua", "-- new note\nlocal a = 1\n")
    local bufnr = h.open(dir, "a.lua")
    h.assert_eq(h.marks(bufnr)[1], "Change")
end

function M.test_string_content_change_is_semantic()
    local dir = h.repo({ ["a.lua"] = 'print("a b")\n' })
    h.write(dir, "a.lua", 'print("a  b")\n')
    local bufnr = h.open(dir, "a.lua")
    h.assert_eq(h.marks(bufnr)[1], "Change", "whitespace inside a string is a real change")
end

function M.test_file_outside_repo_is_ignored()
    sd.disable()
    local dir = vim.fn.tempname()
    local path = h.write(dir, "a.lua", "local a = 1\n")
    vim.cmd("edit! " .. vim.fn.fnameescape(path))
    local bufnr = vim.api.nvim_get_current_buf()
    sd.enable("HEAD")
    vim.wait(600)
    h.assert_eq(h.marks(bufnr), {})
    h.assert_eq(sd._generation(bufnr), 0, "no difft run for a file outside git")
end

function M.test_scratch_buffer_is_ignored()
    sd.disable()
    vim.cmd("enew!")
    vim.bo.buftype = "nofile"
    local bufnr = vim.api.nvim_get_current_buf()
    sd.enable("HEAD")
    vim.wait(600)
    h.assert_eq(sd._generation(bufnr), 0)
end

function M.test_refresh_after_edit_updates_marks()
    local dir = h.repo({ ["a.lua"] = "local a = 1\n" })
    local bufnr = h.open(dir, "a.lua")
    h.assert_eq(h.marks(bufnr), {})

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "local a = 2" })
    sd.refresh(bufnr)
    h.wait_run(bufnr)
    h.assert_eq(h.marks(bufnr)[1], "Change")
end

function M.test_disable_clears_marks_and_state()
    local dir = h.repo({ ["a.lua"] = "local a = 1\n" })
    h.write(dir, "a.lua", "local a = 2\n")
    local bufnr = h.open(dir, "a.lua")
    h.assert_eq(h.marks(bufnr)[1], "Change")

    sd.disable()
    h.assert_eq(sd.active(), false)
    h.assert_eq(h.marks(bufnr), {})
end

function M.test_nav_skips_format_lines_and_wraps()
    local dir = h.repo({ ["a.lua"] = "local a = 1\nlocal b = 2\nlocal c = 3\n" })
    h.write(dir, "a.lua", "local a  = 1\nlocal b = 9\nlocal c  = 3\nlocal d = 4\n")
    local bufnr = h.open(dir, "a.lua")
    h.assert_eq(h.marks(bufnr), { "Format", "Change", "Format", "Add" })

    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    local visited = {}
    for _ = 1, 3 do
        sd.nav("next")
        visited[#visited + 1] = vim.api.nvim_win_get_cursor(0)[1]
    end
    h.assert_eq(visited, { 2, 4, 2 }, "next skips dim lines and wraps")
    sd.nav("prev")
    h.assert_eq(vim.api.nvim_win_get_cursor(0)[1], 4, "prev wraps backwards")
end

function M.test_format_highlight_survives_colorscheme_switch()
    vim.cmd("colorscheme blue")
    vim.cmd("colorscheme default")
    h.assert_eq(vim.api.nvim_get_hl(0, { name = "StructDiffFormat" }).link, "NonText")
end

function M.test_empty_file_both_sides()
    local dir = h.repo({ ["a.lua"] = "" })
    local bufnr = h.open(dir, "a.lua")
    h.assert_eq(h.marks(bufnr), {})
end

return M
