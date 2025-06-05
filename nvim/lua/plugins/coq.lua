return {
    "ms-jpq/coq_nvim",
    branch = "coq",
    init = function()
        vim.g.coq_settings = {
            auto_start = 'shut-up',
            match = { fuzzy_cutoff = 0.8 },
            weights = { prefix_matches = 3 },
            display = { pum = { fast_close = false } },
            completion = {
                skip_after = { "{", "}", "(", ")", "<", ">", "'", "\"", " ", ",", ";", ":", "?", "!" },
            },
            clients = {
                snippets = { enabled = false },
                buffers = { enabled = false }
            },
            keymap = {
                manual_complete = 'c-l',
            }
        }
    end,
    config = function()

        -- Configure language servers using vim.lsp.config
        vim.lsp.config.clangd = {
            cmd = { "clangd", "-std=c++20" },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_markers = {
                "compile_commands.json",
                "compile_flags.txt",
                ".clangd",
                ".git"
            }
        }

        vim.lsp.config.gopls = {
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_markers = { "go.mod", "go.work", ".git" },
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                    staticcheck = true,
                    codelenses = {
                        test = true,
                        tidy = true,
                        upgrade_dependency = true,
                    },
                },
            },
        }

        vim.lsp.config.intelephense = {
            cmd = { "intelephense", "--stdio" },
            filetypes = { "php" },
            root_markers = { "composer.json", ".git" }
        }

        vim.lsp.config.rust_analyzer = {
            cmd = { "rust-analyzer" },
            filetypes = { "rust" },
            root_markers = { "Cargo.toml", ".git" }
        }

        vim.lsp.config.lua_ls = {
            cmd = { "lua-language-server" },
            filetypes = { "lua" },
            root_markers = {
                ".luarc.json",
                ".luarc.jsonc",
                ".luacheckrc",
                ".stylua.toml",
                "stylua.toml",
                "selene.toml",
                "selene.yml",
                ".git",
            }
        }

        vim.lsp.config.texlab = {
            cmd = { "texlab" },
            filetypes = { "tex", "plaintex", "bib" },
            root_markers = { ".latexmkrc", ".git" }
        }

        vim.lsp.config.ts_ls = {
            cmd = { "typescript-language-server", "--stdio" },
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
            root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" }
        }

        vim.lsp.config.millet = {
            cmd = { "millet" },
            filetypes = { "sml" },
            root_markers = { ".git" }
        }

        vim.lsp.config.ty = {
            cmd = { "ty" },
            filetypes = { "ty" },
            root_markers = { ".git" }
        }

        vim.lsp.config.pyright = {
            cmd = { "pyright-langserver", "--stdio" },
            filetypes = { "python" },
            root_markers = {
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                "pyrightconfig.json",
                ".git"
            },
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        }



        -- Enable all language servers
        vim.lsp.enable({
            "clangd",
            "gopls",
            "intelephense",
            "rust_analyzer",
            "lua_ls",
            "texlab",
            "ts_ls",
            "millet",
            "ty",
            "pyright",
            "pylsp"
        })
    end
}
