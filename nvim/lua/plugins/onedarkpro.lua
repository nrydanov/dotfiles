return {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    opts = function()
        return {
            options = {
                transparency = true, -- Use a transparent background?
            },
            colors = {
                dark_yellow = "#fffab4",
                dark_green = "#7b7410",
                -- Default onelight tones are too bright on #F3F3F3; same hues,
                -- lightness lowered to WCAG contrast ~4.5 (fg matches terminal, comment ~3.5)
                onelight = {
                    bg = "#f3f3f3", -- terminal bg; base for cursorline, selection, etc.
                    fg = "#383a42",
                    black = "#383a42",
                    red = "#d42735",
                    orange = "#a35d0d",
                    yellow = "#95650c",
                    green = "#16800e",
                    cyan = "#2f7881",
                    blue = "#0e77a5",
                    purple = "#8257c4",
                    comment = "#7c818a",
                    gray = "#9a9a9a",
                },
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
                -- Transparent mode paints it with palette bg: lighter than the
                -- terminal in onedark, but invisible in onelight, so darken there
                CursorLine = {
                    bg = { onedark = "${bg}", onelight = "#e9e9e9" },
                },
                CursorLineNr = {
                    fg = "${blue}"
                },
                NvimTreeFolderIcon = {
                    fg = "${blue}"
                },
                NvimTreeRootFolder = {
                    fg = "${green}"
                },
                NvimTreeOpenedFolderName = {
                    fg = "${green}"
                },
                ["@lsp.type.enumMember"] = {
                    fg = "${green}"
                },
                --- Comments
                ["@comment.documentation"] = {
                    fg = "${comment}",
                    italic = true,
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
                },
                ["@variable.go"] = {
                    fg = "${fg}"
                },
                --- Inlay hints
                LspInlayHint = {
                    fg = "${gray}",
                    italic = true,
                },
            }

        }
    end
}
