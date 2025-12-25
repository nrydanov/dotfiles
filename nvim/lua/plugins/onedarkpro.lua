return {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    opts = function()
        local helper = require("onedarkpro.helpers")
        local colors = helper.get_colors() -- берёт палитру текущей темы

        return {
            options = {
                transparency = true, -- Use a transparent background?
            },
            highlights = {
                CursorLineNr = {
                    fg = colors.blue
                },
                NvimTreeFolderIcon = {
                    fg = colors.blue
                },
                NvimTreeRootFolder = {
                    fg = colors.green
                },
                NvimTreeOpenedFolderName = {
                    fg = colors.green
                },
                ["@lsp.type.enumMember"] = {
                    fg = colors.green
                }
            }

        }
    end
}
