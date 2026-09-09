-- Structural diff signs driven by difftastic's JSON output.
--
-- While active, every buffer under the repo is diffed against `<base>:<path>`
-- with `difft --display=json`. Only lines with a *semantic* change get a sign,
-- a line highlight and an inline highlight on the changed tokens; pure
-- reformatting (reflows, indentation) produces no marks at all.
--
-- Doc: https://difftastic.wilfred.me.uk/json_output.html (needs DFT_UNSTABLE=yes)

local M = {}

local ns = vim.api.nvim_create_namespace("structdiff")
local group = vim.api.nvim_create_augroup("structdiff", { clear = true })
local DEBOUNCE_MS = 300

-- state.base: commit to diff against
-- state.bufs[bufnr] = { lines, base_file, base_text, base_lines, timer, run_id, generation }
local state = { base = nil, bufs = {} }

-- Lines git would flag but difft considers pure formatting. A default link
-- survives `:colorscheme`, so no ColorScheme hook is needed.
vim.api.nvim_set_hl(0, "StructDiffFormat", { link = "NonText", default = true })

local function git(args, cwd)
    local res = vim.system(vim.list_extend({ "git", "--no-pager" }, args), { cwd = cwd, text = true }):wait()
    if res.code ~= 0 then
        return nil
    end
    return res.stdout
end

-- difft picks the parser by file name, so temp copies keep the real basename.
local function temp_copy(name, lines)
    local dir = vim.fn.tempname()
    vim.fn.mkdir(dir, "p")
    local path = vim.fs.joinpath(dir, vim.fs.basename(name))
    vim.fn.writefile(lines, path)
    return path
end

-- Old path of `rel` if git sees it as renamed between the base and the
-- working tree (needs the new path to be tracked, which an MR commit is).
local function rename_source(rel, dir)
    local out = git({ "diff", "--name-status", "-M", "-z", "--diff-filter=R", state.base }, dir)
    if not out then
        return nil
    end
    local fields = vim.split(out, "\0", { trimempty = true })
    for i = 1, #fields - 2, 3 do
        if fields[i + 2] == rel then
            return fields[i + 1]
        end
    end
    return nil
end

-- Content of the file at `state.base`, written once per buffer and cached.
local function base_file(bufnr)
    local buf = state.bufs[bufnr]
    if buf.base_file then
        return buf.base_file
    end
    local name = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fs.dirname(name)
    local root = git({ "rev-parse", "--show-toplevel" }, dir)
    if not root then
        return nil
    end
    local rel = vim.fs.relpath(vim.trim(root), name)
    local content = rel and git({ "show", state.base .. ":" .. rel }, dir)
    if rel and not content then
        -- Not at this path in the base: maybe it was renamed since.
        local old = rename_source(rel, dir)
        content = old and git({ "show", state.base .. ":" .. old }, dir)
    end
    buf.base_missing = content == nil
    buf.base_text = content or ""
    local lines = vim.split(buf.base_text, "\n")
    if lines[#lines] == "" then
        lines[#lines] = nil
    end
    buf.base_lines = lines
    buf.base_file = temp_copy(name, lines)
    return buf.base_file
end

local function mark_line(bufnr, lnum, kind)
    local line = lnum - 1
    vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, {
        sign_text = "┃",
        sign_hl_group = "GitSigns" .. kind,
        line_hl_group = "GitSigns" .. kind .. "Ln",
        priority = 6,
    })
end

-- difft columns are byte offsets, same as extmarks; just keep them in range.
local function mark_tokens(bufnr, lnum, kind, changes)
    local len = #(vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or "")
    for _, ch in ipairs(changes) do
        local s, e = math.min(ch.start, len), math.min(ch["end"], len)
        if s < e then
            vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, s, {
                end_col = e,
                hl_group = "GitSigns" .. kind .. "Inline",
                priority = 7,
            })
        end
    end
end

-- Right-hand line numbers a plain line diff would flag, as a set.
local function text_changed_lines(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    -- An empty buffer still has one "" line; git stores it as zero bytes.
    local new = (#lines == 1 and lines[1] == "") and "" or table.concat(lines, "\n") .. "\n"
    local hunks = vim.diff(state.bufs[bufnr].base_text or "", new, { result_type = "indices" })
    local set = {}
    for _, h in ipairs(hunks or {}) do
        for lnum = h[3], h[3] + h[4] - 1 do
            set[lnum] = true
        end
    end
    return set
end

local function mark_format_only(bufnr, lnum)
    vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, 0, {
        sign_text = "┃",
        sign_hl_group = "StructDiffFormat",
        priority = 5,
    })
end

-- For every deleted base line (0-based), the 1-based buffer line it sits
-- above; `last + 1` when the deletion happened at the end of the file.
local function deletion_anchors(aligned, last)
    local anchors, pending = {}, {}
    for _, pair in ipairs(aligned or {}) do
        local lhs, rhs = pair[1], pair[2]
        if rhs == vim.NIL or rhs == nil then
            if lhs ~= vim.NIL and lhs ~= nil then
                pending[#pending + 1] = lhs
            end
        else
            for _, l in ipairs(pending) do
                anchors[l] = math.min(rhs + 1, last + 1)
            end
            pending = {}
        end
    end
    for _, l in ipairs(pending) do
        anchors[l] = last + 1
    end
    return anchors
end

-- One virtual line: base text with the deleted tokens emphasised.
local function deleted_segments(text, changes)
    local segs, pos = {}, 0
    for _, ch in ipairs(changes) do
        local s, e = math.min(ch.start, #text), math.min(ch["end"], #text)
        if s > pos then
            segs[#segs + 1] = { text:sub(pos + 1, s), "GitSignsDeleteVirtLn" }
        end
        if e > s then
            segs[#segs + 1] = { text:sub(s + 1, e), "GitSignsDeleteVirtLnInLine" }
        end
        pos = math.max(pos, e)
    end
    if pos < #text then
        segs[#segs + 1] = { text:sub(pos + 1), "GitSignsDeleteVirtLn" }
    end
    if #segs == 0 then
        segs[1] = { "", "GitSignsDeleteVirtLn" }
    end
    return segs
end

-- Deleted lines render as virtual lines above their anchor (or below the
-- last line); the anchor itself becomes a navigation stop with a "▁" sign
-- unless it already carries a bright mark.
local function mark_deletions(bufnr, result, last, marked, lines)
    local buf = state.bufs[bufnr]
    local anchors = deletion_anchors(result.aligned_lines, last)
    local groups, order = {}, {}
    if result.status == "deleted" then
        -- Buffer emptied: difft sends no chunks, every base line is gone.
        groups[last + 1], order[1] = {}, last + 1
        for i, text in ipairs(buf.base_lines) do
            groups[last + 1][i] = { i - 1, deleted_segments(text, {}) }
        end
    end
    for _, chunk in ipairs(result.chunks or {}) do
        for _, pair in ipairs(chunk) do
            local lhs = pair.lhs
            if lhs and not pair.rhs and buf.base_lines[lhs.line_number + 1] then
                local anchor = anchors[lhs.line_number] or last + 1
                if not groups[anchor] then
                    groups[anchor] = {}
                    order[#order + 1] = anchor
                end
                local text = buf.base_lines[lhs.line_number + 1]
                groups[anchor][#groups[anchor] + 1] = { lhs.line_number, deleted_segments(text, lhs.changes or {}) }
            end
        end
    end
    for _, anchor in ipairs(order) do
        table.sort(groups[anchor], function(a, b)
            return a[1] < b[1]
        end)
        local virt = {}
        for _, item in ipairs(groups[anchor]) do
            virt[#virt + 1] = item[2]
        end
        local above = anchor <= last
        local row = (above and anchor or last) - 1
        vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
            virt_lines = virt,
            virt_lines_above = above,
        })
        local stop = above and anchor or last
        if not marked[stop] then
            marked[stop] = true
            lines[#lines + 1] = stop
            vim.api.nvim_buf_set_extmark(bufnr, ns, stop - 1, 0, {
                sign_text = "▁",
                sign_hl_group = "GitSignsDelete",
                priority = 6,
            })
        end
    end
end

local function apply(bufnr, result)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    local lines, marked = {}, {}
    local last = vim.api.nvim_buf_line_count(bufnr)
    local textual = text_changed_lines(bufnr)

    if result.status == "created" or state.bufs[bufnr].base_missing then
        for lnum = 1, last do
            mark_line(bufnr, lnum, "Add")
            lines[#lines + 1] = lnum
        end
    else
        for _, chunk in ipairs(result.chunks or {}) do
            for _, pair in ipairs(chunk) do
                local rhs = pair.rhs
                if rhs and rhs.line_number + 1 <= last then
                    local lnum = rhs.line_number + 1
                    local kind = pair.lhs and "Change" or "Add"
                    mark_line(bufnr, lnum, kind)
                    mark_tokens(bufnr, lnum, kind, rhs.changes or {})
                    lines[#lines + 1] = lnum
                    marked[lnum] = true
                    textual[lnum] = nil
                end
            end
        end
        mark_deletions(bufnr, result, last, marked, lines)
        -- Whatever git flagged that difft did not: formatting only. Keeping
        -- these visible (dimly) is what makes a missed real change noticeable.
        for lnum in pairs(textual) do
            if lnum <= last then
                mark_format_only(bufnr, lnum)
            end
        end
    end
    -- difft emits chunks in its own order; navigation wants buffer order.
    table.sort(lines)
    state.bufs[bufnr].lines = lines
    state.bufs[bufnr].generation = (state.bufs[bufnr].generation or 0) + 1
end

local function run(bufnr)
    if not (state.base and vim.api.nvim_buf_is_valid(bufnr) and state.bufs[bufnr]) then
        return
    end
    local old = base_file(bufnr)
    if not old then
        return
    end
    local cur_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    if #cur_lines == 1 and cur_lines[1] == "" then
        cur_lines = {} -- an empty buffer is an empty file, not one blank line
    end
    local new = temp_copy(vim.api.nvim_buf_get_name(bufnr), cur_lines)
    -- Runs may overlap; only the latest one is allowed to paint.
    local buf = state.bufs[bufnr]
    buf.run_id = (buf.run_id or 0) + 1
    local run_id = buf.run_id

    vim.system(
        { "difft", "--display=json", "--color=never", old, new },
        { text = true, env = { DFT_UNSTABLE = "yes" } },
        vim.schedule_wrap(function(res)
            vim.fn.delete(vim.fs.dirname(new), "rf")
            local ok, decoded = pcall(vim.json.decode, res.stdout or "")
            if not ok or type(decoded) ~= "table" then
                return vim.notify("structdiff: difft failed: " .. vim.trim(res.stderr or ""), vim.log.levels.WARN)
            end
            local cur = state.bufs[bufnr]
            if cur and cur.run_id == run_id and vim.api.nvim_buf_is_valid(bufnr) then
                apply(bufnr, decoded)
            end
        end)
    )
end

function M.refresh(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if not state.base or vim.api.nvim_buf_get_name(bufnr) == "" or vim.bo[bufnr].buftype ~= "" then
        return
    end
    local buf = state.bufs[bufnr]
    if not buf then
        buf = { lines = {} }
        state.bufs[bufnr] = buf
    end
    if buf.timer then
        buf.timer:stop()
    end
    buf.timer = vim.defer_fn(function()
        run(bufnr)
    end, DEBOUNCE_MS)
end

local function detach(bufnr)
    local buf = state.bufs[bufnr]
    if not buf then
        return
    end
    if buf.timer then
        buf.timer:stop()
    end
    if buf.base_file then
        vim.fn.delete(vim.fs.dirname(buf.base_file), "rf")
    end
    if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    end
    state.bufs[bufnr] = nil
end

--- Number of completed difft runs for a buffer (tests wait on it).
function M._generation(bufnr)
    local buf = state.bufs[bufnr or vim.api.nvim_get_current_buf()]
    return buf and buf.generation or 0
end

function M.active()
    return state.base ~= nil
end

function M.enable(base)
    M.disable()
    state.base = base

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged", "InsertLeave" }, {
        group = group,
        callback = function(ev)
            M.refresh(ev.buf)
        end,
    })
    vim.api.nvim_create_autocmd("BufDelete", {
        group = group,
        callback = function(ev)
            detach(ev.buf)
        end,
    })
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
            M.refresh(bufnr)
        end
    end
end

function M.disable()
    vim.api.nvim_clear_autocmds({ group = group })
    for bufnr in pairs(state.bufs) do
        detach(bufnr)
    end
    state.base = nil
end

--- Jump to the next/previous marked line, wrapping around like gitsigns.
--- @param dir "next" | "prev"
function M.nav(dir)
    local buf = state.bufs[vim.api.nvim_get_current_buf()]
    local lines = buf and buf.lines or {}
    if #lines == 0 then
        return vim.notify("structdiff: no changes", vim.log.levels.INFO)
    end
    local cur = vim.api.nvim_win_get_cursor(0)[1]
    local target
    if dir == "next" then
        for _, l in ipairs(lines) do
            if l > cur then
                target = l
                break
            end
        end
        target = target or lines[1]
    else
        for i = #lines, 1, -1 do
            if lines[i] < cur then
                target = lines[i]
                break
            end
        end
        target = target or lines[#lines]
    end
    vim.api.nvim_win_set_cursor(0, { target, 0 })
end

return M
