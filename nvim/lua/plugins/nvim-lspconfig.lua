return {
    "neovim/nvim-lspconfig",
    dependencies = { "ms-jpq/coq_nvim" },
    config = function()
        local lsp = require("lspconfig")
        local coq = require("coq")

        -- Define LSP server-specific settings
        local settings = {
            typst_lsp = {
                exportPdf = "onType",
                serverPath = "",
            },
            pylsp = {
                plugins = {
                    ruff = {
                        enabled = true,
                        extendSelect = { "I", "E", "F" },
                        format = { "I" },
                        unsafeFixes = false,
                    },
                    rope_autoimport = {
                        enabled = true,
                    },
                },
            },
            Lua = {
                diagnostics = {
                    globals = { "vim", "require" },
                },
            },
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
            },
        }

        -- List of servers to set up
        local servers = {
            "pyright",
            "clangd",
            "gopls",
            "intelephense",
            "rust_analyzer",
            "lua_ls",
            "ruff",
            "texlab",
            "millet",
            "ts_ls"
        }

        -- Setup each LSP server using COQ capabilities
        for _, server in ipairs(servers) do
            local server_settings = settings[server] or {}

            lsp[server].setup(coq.lsp_ensure_capabilities {
                settings = server_settings,
            })
        end

    end,
}
