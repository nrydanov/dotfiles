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
    "ruff_lsp",
    "texlab",
    "millet"
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
    gopls = {
        analyses = {
            unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
    }
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
            cargo = {
                features = "all"
            },
            -- checkOnSave = {
            --     command = "clippy",
            -- },
            procMacro = {
                ignored = {
                    leptos_macro = {
                        -- optional: --
                        -- "component",
                        -- "server",
                    },
                },
            },
        },
    }
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.sml",
    callback = function()
        -- Get the root directory (current working directory)
        local root_dir = vim.fn.getcwd()
        -- Compute the relative path from the root directory to the current file
        local relative_path = vim.fn.expand("%:.")

        -- Define the path to the sources.mlb file in the root directory
        local sources_file = root_dir .. '/sources.mlb'
        local toml_file = root_dir .. '/millet.toml'
        -- Open the sources.mlb file in write mode
        local f = io.open(sources_file, 'w')
        local toml = io.open(toml_file, 'w')
        if toml then
            toml:close()
        end
        if f then
            -- Write the relative path into the sources.mlb file
            f:write(relative_path .. '\n')
            f:close()
        else
            print('Could not open ' .. sources_file .. ' for writing')
        end
        vim.cmd(":LspRestart")
    end
})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
    pattern = "*.sml",
    callback = function()
        local root_dir = vim.fn.getcwd()
        local sources_file = root_dir .. '/sources.mlb'
        local toml_file = root_dir .. "/millet.toml"
        os.remove(sources_file)
        os.remove(toml_file)
    end
})
