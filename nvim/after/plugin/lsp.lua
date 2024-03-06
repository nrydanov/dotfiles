require "lsp_signature".setup {}
require "luasnip.loaders.from_vscode".load {}

local lsp = require "lspconfig"

local servers = {
    "pylsp",
    "clangd",
    "gopls",
    "intelephense",
    "rust_analyzer",
    "typst_lsp",
    "lua_ls"
}

local settings = {
    typst_lsp = {
        exportPdf = "onType",
        serverPath = ""
    },
    pylsp = {
        plugins = {
            ruff = {
                enabled = true,
                extendSelect = { "I", "E", "F" },
                format = { "I" },
                unsafeFixes = false
            },
        },
    },
    typst_lsp = {
        exportPdf = "onType",
        serverPath = ""
    },
    Lua = {
        diagnostics = {
            globals = { 'vim', 'require' }
        }
    }
}

for _, server in ipairs(servers) do
    lsp[server].setup({ settings = settings })
end
