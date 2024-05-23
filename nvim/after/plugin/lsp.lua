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
    "lua_ls",
    "ruff_lsp"
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
            rope_autoimport = {
                enabled = true,
            },
        },
    },
    Lua = {
        diagnostics = {
            globals = { 'vim', 'require' }
        }
    },
}

for _, server in ipairs(servers) do
    lsp[server].setup({ settings = settings })
end


require('lspconfig').rust_analyzer.setup {
    -- Other Configs ...
    settings = {
        ["rust-analyzer"] = {
            rustfmt = {
                overrideCommand = { 'leptosfmt', '--stdin', '--rustfmt' }
            },
            -- Other Settings ...
            checkOnSave = {
                    command = "clippy",
                },
            procMacro = {
                ignored = {
                    leptos_macro = {
                        -- optional: --
                        -- "component",
                        "server",
                    },
                },
            },
        },
    }
}
