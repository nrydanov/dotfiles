local M = {}

local function repo_dir()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return vim.uv.cwd()
    end
    return vim.fn.fnamemodify(name, ":h")
end

local function repo_root()
    local cwd = repo_dir()
    return Snacks.git.get_root(cwd) or cwd
end

local function git(args, cwd)
    local res = vim.system(vim.list_extend({ "git", "--no-pager" }, args), { cwd = cwd, text = true }):wait()
    if res.code ~= 0 then
        return nil, vim.trim(res.stderr or "")
    end
    return vim.trim(res.stdout)
end

local function merge_base(target, root)
    local base, err = git({ "merge-base", target, "HEAD" }, root)
    if not base then
        vim.notify("MR review: " .. (err or "merge-base failed"), vim.log.levels.ERROR)
        return nil
    end
    return base
end

local function state_path(root)
    local slug = root:gsub("[^%w]", "_")
    return vim.fs.joinpath(vim.fn.stdpath("state"), "mr-review", slug .. ".json")
end

local function load_state(root)
    local path = state_path(root)
    local ok, content = pcall(vim.fn.readfile, path)
    if not ok or #content == 0 then
        return {}
    end
    local decoded_ok, decoded = pcall(vim.json.decode, table.concat(content, "\n"))
    return decoded_ok and type(decoded) == "table" and decoded or {}
end

local function save_state(root, state)
    local path = state_path(root)
    vim.fn.mkdir(vim.fs.dirname(path), "p")
    vim.fn.writefile(vim.split(vim.json.encode(state), "\n"), path)
end

local BASE_KEY = ".base"

local target_cache = {}

local function detect_target(root)
    local head = git({ "symbolic-ref", "--short", "refs/remotes/origin/HEAD" }, root)
    if head then
        return head
    end
    for _, name in ipairs({ "origin/main", "origin/master", "main", "master" }) do
        if git({ "rev-parse", "--verify", "--quiet", name }, root) then
            return name
        end
    end
    return "main"
end

local function resolve_target(root)
    local saved = load_state(root)[BASE_KEY]
    if type(saved) == "string" then
        return saved
    end
    if not target_cache[root] then
        target_cache[root] = detect_target(root)
    end
    return target_cache[root]
end

local function store_target(root, target)
    local state = load_state(root)
    state[BASE_KEY] = target
    save_state(root, state)
end

function M.status_symbol(sha, changed)
    if not sha then
        return " "
    end
    if changed == nil then
        return "?"
    end
    return changed and "~" or "✓"
end

local function reviewed_status(root, target, files)
    local marks = load_state(root)[target] or {}
    local by_sha = {}
    for file, sha in pairs(marks) do
        by_sha[sha] = by_sha[sha] or {}
        by_sha[sha][file] = true
    end

    local changed = {}
    for sha in pairs(by_sha) do
        -- Compare the reviewed commit against the working tree, not against
        -- HEAD: a file edited but not yet committed has still moved since the
        -- review and must not keep rendering as done.
        local out = git({ "diff", "--name-only", sha }, root)
        local moved = out and vim.split(out, "\n", { trimempty = true })
        for file in pairs(by_sha[sha]) do
            if moved then
                changed[file] = vim.tbl_contains(moved, file)
            end
        end
    end

    local status = {}
    for _, file in ipairs(files) do
        status[file] = M.status_symbol(marks[file], changed[file])
    end
    return status
end

local function rel_path(root)
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return nil
    end
    return vim.fs.relpath(root, name)
end

function M.on(target)
    local root = repo_root()
    target = target or resolve_target(root)
    local base = merge_base(target, root)
    if not base then
        return
    end

    local gs = require("gitsigns")
    gs.change_base(base, true)
    gs.toggle_linehl(true)
    vim.notify("MR review: diffing against " .. target)
end

--- Same as `on`, but marks come from difftastic: lines that only changed
--- formatting stay clean. gitsigns keeps the base for stage/reset, its own
--- signs go quiet so the two don't disagree in the sign column.
function M.on_structural(target)
    local root = repo_root()
    target = target or resolve_target(root)
    local base = merge_base(target, root)
    if not base then
        return
    end

    local gs = require("gitsigns")
    gs.change_base(base, true)
    gs.toggle_linehl(false)
    gs.toggle_signs(false)
    require("config.structdiff").enable(base)
    vim.notify("MR review (structural): diffing against " .. target)
end

function M.set_base()
    local root = repo_root()
    Snacks.picker.git_branches({
        all = true,
        cwd = root,
        title = "MR review base",
        confirm = function(picker, item)
            picker:close()
            local branch = item and (item.branch or item.commit)
            if not branch then
                return
            end
            branch = branch:gsub("^remotes/", "")
            store_target(root, branch)
            M.on(branch)
        end,
    })
end

function M.off()
    require("config.structdiff").disable()
    local gs = require("gitsigns")
    gs.change_base(nil, true)
    gs.toggle_linehl(false)
    gs.toggle_signs(true)
    vim.notify("MR review: off")
end

local function set_reviewed(root, target, files, sha)
    local state = load_state(root)
    state[target] = state[target] or {}
    for _, file in ipairs(files) do
        state[target][file] = sha
    end
    if vim.tbl_isempty(state[target]) then
        state[target] = nil
    end
    save_state(root, state)
end

function M.toggle_reviewed(target)
    local root = repo_root()
    target = target or resolve_target(root)
    local file = rel_path(root)
    if not file then
        vim.notify("MR review: current buffer is not a file in " .. root, vim.log.levels.WARN)
        return
    end

    local marks = load_state(root)[target] or {}
    if marks[file] then
        set_reviewed(root, target, { file }, nil)
        vim.notify("MR review: " .. file .. " unmarked")
    else
        local head = git({ "rev-parse", "HEAD" }, root)
        set_reviewed(root, target, { file }, head)
        vim.notify("MR review: " .. file .. " reviewed")
    end
end

function M.since_review(target)
    local root = repo_root()
    target = target or resolve_target(root)
    local file = rel_path(root)
    local sha = file and (load_state(root)[target] or {})[file]
    if not sha then
        vim.notify("MR review: " .. (file or "buffer") .. " was never reviewed", vim.log.levels.WARN)
        return
    end

    require("gitsigns").change_base(sha, false)
    local sd = require("config.structdiff")
    if sd.active() then
        sd.enable(sha)
    end
    vim.notify("MR review: showing changes since your review")
end

local function changed_items(base, root)
    local out, err = git({ "diff", "--name-status", "-z", base }, root)
    if not out then
        vim.notify("MR review: " .. (err or "diff failed"), vim.log.levels.ERROR)
        return nil
    end

    local fields = vim.split(out, "\0", { trimempty = true })
    local items, files = {}, {}
    local i = 1
    while i < #fields do
        local status, file = fields[i], fields[i + 1]
        i = i + 2
        local kind = status:sub(1, 1)
        if kind == "R" or kind == "C" then
            file = fields[i]
            i = i + 1
        end
        items[#items + 1] = { cwd = root, file = file, text = file, status = " " .. kind }
        files[#files + 1] = file
    end
    return items, files
end

function M.files(target)
    local root = repo_root()
    target = target or resolve_target(root)
    local base = merge_base(target, root)
    if not base then
        return
    end

    local items, files = changed_items(base, root)
    if not items then
        return
    end
    local status = reviewed_status(root, target, files)

    Snacks.picker.pick({
        source = "mr_files",
        title = "MR files vs " .. target,
        items = items,
        format = function(item, picker)
            local symbol = status[item.file] or " "
            local hl = symbol == "✓" and "SnacksPickerGitStatusAdded" or "SnacksPickerGitStatusModified"
            local ret = { { symbol, hl }, { " " } }
            return vim.list_extend(ret, Snacks.picker.format.git_status(item, picker))
        end,
        preview = function(ctx)
            Snacks.picker.preview.cmd(
                { "git", "--no-pager", "diff", "--no-ext-diff", base, "--", ctx.item.file },
                ctx,
                { ft = "diff" }
            )
        end,
        actions = {
            toggle_reviewed = function(picker)
                local selected = picker:selected({ fallback = true })
                local marks = load_state(root)[target] or {}

                -- Toggle each file on its own. Stamping a whole mixed selection
                -- with the current HEAD would erase the stale (~) marker on
                -- files reviewed at an older commit without them being re-read.
                local to_mark, to_unmark = {}, {}
                for _, item in ipairs(selected) do
                    local bucket = marks[item.file] and to_unmark or to_mark
                    bucket[#bucket + 1] = item.file
                end

                if #to_mark > 0 then
                    set_reviewed(root, target, to_mark, git({ "rev-parse", "HEAD" }, root))
                end
                if #to_unmark > 0 then
                    set_reviewed(root, target, to_unmark, nil)
                end

                status = reviewed_status(root, target, files)
                picker.list:update({ force = true })
            end,
        },
        win = {
            input = { keys = { ["<c-r>"] = { "toggle_reviewed", mode = { "i", "n" } } } },
            list = { keys = { ["<c-r>"] = "toggle_reviewed" } },
        },
    })
end

return M
