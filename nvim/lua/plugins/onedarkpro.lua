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
            colors = {
                dark_yellow = "#fffab4",
                dark_green = "#7b7410",
            },
            highlights = {
                --- Brackets
                Brackets = {
                    link = "Normal",
                },
                ["@punctuation.bracket.rust"] = {
                    link = "Brackets",
                },
                ["@odp.punctuation_arguments_brackets.rust"] = {
                    link = "Brackets",
                },
                ["@odp.punctuation_token_bracket.rust"] = {
                    link = "Brackets",
                },
                --- Misc
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
                },
                --- Comments
                ["@comment.documentation"] = {
                    bg = "${dark_yellow}",
                    fg = "${dark_green}",
                    bold = true,
                },
                --- Literals, Variables and functions
                ["@variable.builtin"] = {
                    link = "@variable"
                },
                ["@function.builtin"] = {
                    link = "@function"
                },
                ["@variable.parameter"] = {
                    link = "@variable"
                },
                ["@lsp.type.macro.rust"] = {
                    link = "@function"
                }
            }

        }
    end
}
