return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        disable_netrw = true,
        hijack_netrw = true,
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        view = {
            relativenumber = true,
            float = {
                enable = true,
                open_win_config = function()
                    local HEIGHT_RATIO = 0.8 -- Adjusted here for easy modification
                    local WIDTH_RATIO = 0.5  -- Adjusted here for easy modification
                    local screen_w = vim.opt.columns:get()
                    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                    local window_w = screen_w * WIDTH_RATIO
                    local window_h = screen_h * HEIGHT_RATIO
                    local window_w_int = math.floor(window_w)
                    local window_h_int = math.floor(window_h)
                    local center_x = (screen_w - window_w) / 2
                    local center_y = ((vim.opt.lines:get() - window_h) / 2)
                        - vim.opt.cmdheight:get()
                    return {
                        border = "rounded",
                        relative = "editor",
                        row = center_y,
                        col = center_x,
                        width = window_w_int,
                        height = window_h_int,
                    }
                end,
            },
            width = function()
                local WIDTH_RATIO = 0.5
                return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
            end,
        },
        filters = {
            custom = { "^.git$" },
        },
        renderer = {
            indent_width = 1,
        },
    },
    init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        vim.opt.termguicolors = true

        local function open_nvim_tree(data)
            -- buffer is a directory
            local directory = vim.fn.isdirectory(data.file) == 1

            if not directory then
                return
            end

            -- create a new, empty buffer
            vim.cmd.enew()

            -- wipe the directory buffer
            vim.cmd.bw(data.buf)

            -- change to the directory
            vim.cmd.cd(data.file)

            -- open the tree
            require("nvim-tree.api").tree.open()
        end

        vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
    end,
}
