local M = {}

local ns = vim.api.nvim_create_namespace("structdiff")
local overlay_ns = vim.api.nvim_create_namespace("structdiff_overlay")
local group = "StructDiffSigns"
local state = {}

local defaults = {
    base = "HEAD",
    signs = true,
    debounce_ms = 250,
    preview = {
        width = 0.85,
        height = 0.75,
        border = "rounded",
        context = 3,
    },
    overlay = {
        context = 3,
    },
}

local config = vim.deepcopy(defaults)
local preview_win
local refresh_timer


local function setup_overlay_highlights()
    vim.api.nvim_set_hl(0, "StructDiffAdd", { fg = "#5fd787", bold = true, bg = "#1a3a1a" })
    vim.api.nvim_set_hl(0, "StructDiffAddToken", { fg = "#5fd787", bold = true })
    vim.api.nvim_set_hl(0, "StructDiffDelete", { fg = "#ff5f5f", bg = "#3a1a1a" })
    vim.api.nvim_set_hl(0, "StructDiffDeletedLine", { fg = "#ff5f5f", italic = true })
    vim.api.nvim_set_hl(0, "StructDiffMeta", { fg = "#87afff", bold = true })
end

local function strip_ansi(text)
    return text:gsub("\27%[[%d;]*m", "")
end

local function parse_line_segments(line_text)
    local segments = {}
    local pos = 1
    local current_hl = nil
    local emphasized = false

    while pos <= #line_text do
        local esc_start, esc_end, codes = line_text:find("\27%[([%d;]*)m", pos)
        if esc_start then
            if esc_start > pos then
                local text = line_text:sub(pos, esc_start - 1)
                local hl = current_hl
                if emphasized and current_hl == "StructDiffAddToken" then hl = "StructDiffAdd" end
                table.insert(segments, { text, hl or "Normal" })
            end
            if codes == "0" or codes == "" or codes == "39" then
                current_hl = nil
                emphasized = false
            elseif codes == "92;1;4" then
                current_hl = "StructDiffAdd"
                emphasized = true
            elseif codes == "92;1" or codes == "92" then
                current_hl = "StructDiffAddToken"
                emphasized = false
            elseif codes == "91;1;4" or codes == "91;1" or codes == "91" then
                current_hl = "StructDiffDelete"
                emphasized = codes == "91;1;4"
            elseif codes == "1" then
                current_hl = "StructDiffMeta"
                emphasized = false
            elseif codes == "2" then
                current_hl = "Comment"
                emphasized = false
            end
            pos = esc_end + 1
        else
            local text = line_text:sub(pos)
            if #text > 0 then table.insert(segments, { text, current_hl or "Normal" }) end
            break
        end
    end
    return segments
end

local function difft_content(clean)
    if clean:match("^   %d+") then
        return clean:gsub("^   %d+ ?", "", 1)
    end

    local rest = clean:gsub("^%s*%d+", "", 1)
    -- Old-side difftastic lines include a small separator column between the
    -- line number and source text. Remove that separator, but keep source
    -- indentation intact.
    if rest:sub(1, 4) == "    " then
        return rest:sub(5)
    end
    return rest:gsub("^ ?", "", 1)
end

local function segments_for_content(line, content)
    local parsed = parse_line_segments(line)
    local flat = {}
    for _, seg in ipairs(parsed) do
        table.insert(flat, seg[1])
    end
    local text = table.concat(flat)
    local start = text:find(content, 1, true)
    if not start then
        return { { content, "Normal" } }
    end

    local out = {}
    local pos = 1
    local finish = start + #content - 1
    for _, seg in ipairs(parsed) do
        local seg_text, hl = seg[1], seg[2]
        local seg_start = pos
        local seg_finish = pos + #seg_text - 1
        if seg_finish >= start and seg_start <= finish then
            local a = math.max(start, seg_start) - seg_start + 1
            local b = math.min(finish, seg_finish) - seg_start + 1
            table.insert(out, { seg_text:sub(a, b), hl })
        end
        pos = seg_finish + 1
    end
    return out
end

local function parse_difftastic_overlay(output)
    local changes = { additions = {}, modifications = {}, deletions = {} }
    local deleted_content = {}
    local deleted_lines = {}

    for _, line in ipairs(vim.split(output, "\n", { plain = true })) do
        if line:find("\27%[91") then
            local clean = strip_ansi(line)
            local old_num = clean:match("^%s*(%d+)")
            if old_num then
                local content = difft_content(clean)
                if content and content ~= "" then
                    deleted_content[content] = tonumber(old_num)
                    table.insert(deleted_lines, { line_num = tonumber(old_num), content = content })
                end
            end
        end
    end

    for _, line in ipairs(vim.split(output, "\n", { plain = true })) do
        if not line:match("%-%-%-") and line:find("\27%[92") then
            local clean = strip_ansi(line)
            local line_num = clean:match("^   (%d+)")
            if line_num then
                line_num = tonumber(line_num)
                local content = difft_content(clean)
                if content and content ~= "" then
                    local segments = segments_for_content(line, content)
                    local is_modification = false
                    local matched_deleted
                    for deleted in pairs(deleted_content) do
                        local prefix_len = math.min(20, #deleted, #content)
                        if prefix_len > 0 then
                            local matches = 0
                            for j = 1, prefix_len do
                                if deleted:sub(j, j) == content:sub(j, j) then matches = matches + 1 end
                            end
                            if matches / prefix_len > 0.7 then
                                is_modification = true
                                matched_deleted = deleted
                                break
                            end
                        end
                    end
                    if is_modification then
                        table.insert(changes.modifications, { line_num = line_num, segments = segments })
                        if matched_deleted then deleted_content[matched_deleted] = nil end
                    else
                        table.insert(changes.additions, { line_num = line_num, segments = segments })
                    end
                end
            end
        end
    end

    for _, deletion in ipairs(deleted_lines) do
        if deleted_content[deletion.content] then
            table.insert(changes.deletions, deletion)
        end
    end
    return changes
end

local function notify(msg, level, opts)
    opts = opts or {}
    if opts.silent then return end
    vim.notify(msg, level or vim.log.levels.INFO, { title = "StructDiff" })
end

local function shell(cmd, opts)
    opts = opts or {}
    local out = vim.fn.system(cmd)
    return out, vim.v.shell_error
end

local function buf_path(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" then return nil end
    return path
end

local function git_root(path)
    local cmd = "git -C " .. vim.fn.shellescape(vim.fn.fnamemodify(path, ":h")) .. " rev-parse --show-toplevel 2>/dev/null"
    local out, code = shell(cmd)
    if code ~= 0 then return nil end
    return vim.trim(out)
end

local function rel_path(root, path)
    local prefix = root:gsub("/$", "") .. "/"
    if vim.startswith(path, prefix) then
        return path:sub(#prefix + 1)
    end
    return path
end

local function is_tracked(root, rel)
    local _, code = shell("git -C " .. vim.fn.shellescape(root) .. " ls-files --error-unmatch -- " .. vim.fn.shellescape(rel) .. " >/dev/null 2>&1")
    return code == 0
end

local function sign_name(kind)
    if kind == "add" then return "StructDiffAdd" end
    if kind == "delete" then return "StructDiffDelete" end
    return "StructDiffChange"
end

function M._parse_hunks(diff)
    local hunks = {}
    for old_start, old_count, new_start, new_count in diff:gmatch("@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@") do
        old_count = tonumber(old_count ~= "" and old_count or "1")
        new_start = tonumber(new_start)
        new_count = tonumber(new_count ~= "" and new_count or "1")

        local kind = "change"
        if old_count == 0 then
            kind = "add"
        elseif new_count == 0 then
            kind = "delete"
        end

        local start_line = math.max(new_start, 1)
        local finish_line = math.max(start_line, new_start + math.max(new_count, 1) - 1)
        table.insert(hunks, {
            start = start_line,
            finish = finish_line,
            kind = kind,
        })
    end
    return hunks
end

local function clear(bufnr)
    bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
    vim.fn.sign_unplace(group, { buffer = bufnr })
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    state[bufnr] = state[bufnr] or {}
    state[bufnr].hunks = {}
end

local function place_signs(bufnr, hunks)
    bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
    if not config.signs then return end
    vim.fn.sign_unplace(group, { buffer = bufnr })
    for i, hunk in ipairs(hunks) do
        vim.fn.sign_place(i, group, sign_name(hunk.kind), bufnr, {
            lnum = hunk.start,
            priority = 8,
        })
    end
end

function M.refresh(bufnr, opts)
    opts = opts or {}
    bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(bufnr) then return false end
    local path = buf_path(bufnr)
    if not path then
        clear(bufnr)
        notify("buffer has no file path", vim.log.levels.WARN, opts)
        return false
    end

    local root = git_root(path)
    if not root then
        clear(bufnr)
        notify("not in a git repository", vim.log.levels.WARN, opts)
        return false
    end

    local rel = rel_path(root, path)
    if not is_tracked(root, rel) then
        clear(bufnr)
        notify("file is untracked; git has no base version for structural diff", vim.log.levels.WARN, opts)
        return false
    end

    local diff_cmd = table.concat({
        "git -C", vim.fn.shellescape(root),
        "diff --no-ext-diff --no-color --unified=0", config.base,
        "--", vim.fn.shellescape(rel),
        "2>&1",
    }, " ")
    local diff, code = shell(diff_cmd)
    if code ~= 0 then
        clear(bufnr)
        notify(vim.trim(diff ~= "" and diff or "git diff failed"), vim.log.levels.ERROR, opts)
        return false
    end

    local hunks = M._parse_hunks(diff)
    state[bufnr] = {
        root = root,
        rel = rel,
        path = path,
        hunks = hunks,
    }
    place_signs(bufnr, hunks)

    if #hunks == 0 then
        notify("no changes", vim.log.levels.INFO, opts)
        return false
    end
    return true
end

local function current_state(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if not state[bufnr] or not state[bufnr].hunks or #state[bufnr].hunks == 0 then
        M.refresh(bufnr, { silent = true })
    end
    return state[bufnr]
end

local function current_hunk_index(bufnr, direction)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local st = current_state(bufnr)
    if not st or not st.hunks or #st.hunks == 0 then return nil end
    local cursor = vim.api.nvim_win_get_cursor(0)[1]

    if direction == "prev" then
        for i = #st.hunks, 1, -1 do
            if st.hunks[i].start < cursor then return i end
        end
        return #st.hunks
    end

    for i, hunk in ipairs(st.hunks) do
        if hunk.start > cursor then return i end
    end
    return 1
end

local function jump(direction)
    local bufnr = vim.api.nvim_get_current_buf()
    local idx = current_hunk_index(bufnr, direction)
    local st = state[bufnr]
    if not idx or not st or not st.hunks[idx] then
        notify("no structural changes")
        return false
    end
    vim.api.nvim_win_set_cursor(0, { st.hunks[idx].start, 0 })
    return true
end

function M.next_hunk()
    return jump("next")
end

function M.prev_hunk()
    return jump("prev")
end

function M.close_preview()
    if preview_win and vim.api.nvim_win_is_valid(preview_win) then
        vim.api.nvim_win_close(preview_win, true)
    end
    preview_win = nil
end

local function write_temp(lines)
    local file = vim.fn.tempname()
    vim.fn.writefile(lines, file)
    return file
end

local function base_file_lines(root, rel)
    local out, code = shell("git -C " .. vim.fn.shellescape(root) .. " show " .. vim.fn.shellescape(config.base .. ":" .. rel) .. " 2>/dev/null")
    if code ~= 0 then return nil end
    return vim.split(out, "\n", { plain = true })
end

function M.preview_hunk()
    local bufnr = vim.api.nvim_get_current_buf()
    local st = current_state(bufnr)
    if not st or not st.hunks or #st.hunks == 0 then
        notify("no structural changes")
        return false
    end

    if vim.fn.executable("difft") ~= 1 then
        notify("difftastic not found; install with `brew install difftastic`", vim.log.levels.ERROR)
        return false
    end

    local old_lines = base_file_lines(st.root, st.rel)
    if not old_lines then
        notify("could not read base file from " .. config.base, vim.log.levels.ERROR)
        return false
    end
    local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local old_file = write_temp(old_lines)
    local new_file = write_temp(new_lines)
    local cmd = table.concat({
        "difft --display inline --color never --context", tostring(config.preview.context),
        vim.fn.shellescape(old_file),
        vim.fn.shellescape(new_file),
        "2>&1",
    }, " ")
    local out, code = shell(cmd)
    vim.fn.delete(old_file)
    vim.fn.delete(new_file)

    if code ~= 0 and out == "" then
        notify("difft failed", vim.log.levels.ERROR)
        return false
    end
    if vim.trim(out) == "" then
        notify("no structural diff output")
        return false
    end

    M.close_preview()
    local lines = vim.split(out, "\n", { plain = true })
    if lines[#lines] == "" then table.remove(lines, #lines) end

    local p = config.preview
    local width = math.floor(vim.o.columns * p.width)
    local height = math.floor(vim.o.lines * p.height)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    local pbuf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(pbuf, 0, -1, false, lines)
    vim.bo[pbuf].buftype = "nofile"
    vim.bo[pbuf].bufhidden = "wipe"
    vim.bo[pbuf].filetype = "diff"
    vim.bo[pbuf].modifiable = false
    preview_win = vim.api.nvim_open_win(pbuf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = p.border,
        title = " StructDiff " .. st.rel .. " ",
        title_pos = "center",
        style = "minimal",
    })
    vim.keymap.set("n", "q", M.close_preview, { buffer = pbuf, nowait = true, silent = true, desc = "Close StructDiff preview" })
    return true
end

local function difftastic_output_for_buffer(bufnr)
    bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
    local st = current_state(bufnr)
    if not st or not st.hunks or #st.hunks == 0 then
        return nil, "no structural changes"
    end
    if vim.fn.executable("difft") ~= 1 then
        return nil, "difftastic not found; install with `brew install difftastic`"
    end
    local old_lines = base_file_lines(st.root, st.rel)
    if not old_lines then
        return nil, "could not read base file from " .. config.base
    end
    local old_file = write_temp(old_lines)
    local new_file = write_temp(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))
    local cmd = table.concat({
        "difft --display inline --color always --context", tostring(config.overlay.context),
        vim.fn.shellescape(old_file),
        vim.fn.shellescape(new_file),
        "2>&1",
    }, " ")
    local out, code = shell(cmd)
    vim.fn.delete(old_file)
    vim.fn.delete(new_file)
    if code ~= 0 and vim.trim(out) == "" then
        return nil, "difft failed"
    end
    if vim.trim(out) == "" then
        return nil, "no structural diff output"
    end
    return out
end

function M.clear_overlay(bufnr)
    bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_clear_namespace(bufnr, overlay_ns, 0, -1)
    end
    state[bufnr] = state[bufnr] or {}
    state[bufnr].overlay = false
    return true
end

local function render_overlay_changes(bufnr, changes)
    bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
    setup_overlay_highlights()
    M.clear_overlay(bufnr)
    local line_count = vim.api.nvim_buf_line_count(bufnr)

    -- Pure additions already exist in the working-tree buffer and are shown by
    -- signs. Rendering them as virtual lines or broad highlights makes the code
    -- look duplicated, so inline overlay intentionally skips additions.

    for _, change in ipairs(changes.modifications or {}) do
        if change.line_num > 0 and change.line_num <= line_count then
            local current_line = vim.api.nvim_buf_get_lines(bufnr, change.line_num - 1, change.line_num, false)[1] or ""
            local search_start = 1
            for _, seg in ipairs(change.segments or {}) do
                local text, hl = seg[1], seg[2]
                if text and #text > 0 then
                    local pos = current_line:find(text, search_start, true)
                    if pos then
                        if hl == "StructDiffAdd" or hl == "StructDiffAddToken" then
                            vim.api.nvim_buf_set_extmark(bufnr, overlay_ns, change.line_num - 1, pos - 1, {
                                end_col = pos - 1 + #text,
                                hl_group = hl,
                                priority = 200,
                            })
                        end
                        search_start = pos + #text
                    end
                end
            end
        end
    end

    for _, deletion in ipairs(changes.deletions or {}) do
        local lnum = math.min(math.max(deletion.line_num - 1, 0), math.max(line_count - 1, 0))
        vim.api.nvim_buf_set_extmark(bufnr, overlay_ns, lnum, 0, {
            virt_lines = { { { "  - " .. deletion.content, "StructDiffDeletedLine" } } },
            virt_lines_above = true,
        })
    end

    state[bufnr] = state[bufnr] or {}
    state[bufnr].overlay = true
    return vim.api.nvim_buf_get_extmarks(bufnr, overlay_ns, 0, -1, { details = true })
end

function M.show_overlay(bufnr)
    bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
    local out, err = difftastic_output_for_buffer(bufnr)
    if not out then
        notify(err, vim.log.levels.WARN)
        return false
    end

    local changes = parse_difftastic_overlay(out)
    local extmarks = render_overlay_changes(bufnr, changes)
    if #extmarks == 0 then
        notify("difftastic produced output, but no inline overlay could be mapped", vim.log.levels.WARN)
        return false
    end
    return true
end
function M.toggle_overlay(bufnr)
    bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
    if state[bufnr] and state[bufnr].overlay then
        return M.clear_overlay(bufnr)
    end
    return M.show_overlay(bufnr)
end

function M.toggle_signs()
    config.signs = not config.signs
    if config.signs then
        M.refresh(0, { silent = true })
        notify("signs enabled")
    else
        vim.fn.sign_unplace(group)
        notify("signs disabled")
    end
    return config.signs
end

local function debounced_refresh(bufnr)
    if refresh_timer then refresh_timer:stop() end
    refresh_timer = vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
            M.refresh(bufnr, { silent = true })
        end
    end, config.debounce_ms)
end

function M.setup(opts)
    config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})

    vim.fn.sign_define("StructDiffAdd", { text = "┃", texthl = "GitSignsAdd", numhl = "" })
    vim.fn.sign_define("StructDiffChange", { text = "┃", texthl = "GitSignsChange", numhl = "" })
    vim.fn.sign_define("StructDiffDelete", { text = "_", texthl = "GitSignsDelete", numhl = "" })

    vim.api.nvim_create_user_command("StructDiffRefresh", function() M.refresh(0) end, { desc = "Refresh structural diff signs" })
    vim.api.nvim_create_user_command("StructDiffNext", M.next_hunk, { desc = "Next structural diff hunk" })
    vim.api.nvim_create_user_command("StructDiffPrev", M.prev_hunk, { desc = "Previous structural diff hunk" })
    vim.api.nvim_create_user_command("StructDiffPreview", M.preview_hunk, { desc = "Preview structural diff" })
    vim.api.nvim_create_user_command("StructDiffToggleOverlay", M.toggle_overlay, { desc = "Toggle inline structural diff overlay" })
    vim.api.nvim_create_user_command("StructDiffToggleSigns", M.toggle_signs, { desc = "Toggle structural diff signs" })
    vim.api.nvim_create_user_command("StructDiffClosePreview", M.close_preview, { desc = "Close structural diff preview" })

    vim.keymap.set("n", "<leader>td", M.toggle_overlay, { desc = "Toggle structural overlay" })
    vim.keymap.set("n", "<leader>tn", M.next_hunk, { desc = "Next structural change" })
    vim.keymap.set("n", "<leader>tp", M.prev_hunk, { desc = "Previous structural change" })
    vim.keymap.set("n", "<leader>tv", M.toggle_signs, { desc = "Toggle structural signs" })
    vim.keymap.set("n", "<leader>tq", M.close_preview, { desc = "Close StructDiff preview" })

    local augroup = vim.api.nvim_create_augroup("StructDiff", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        group = augroup,
        callback = function(ev) M.refresh(ev.buf, { silent = true }) end,
    })
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = augroup,
        callback = function(ev) debounced_refresh(ev.buf) end,
    })
end

M._state = state
M._clear = clear
M._parse_difftastic_overlay = parse_difftastic_overlay
M._render_overlay_changes = render_overlay_changes

return M
