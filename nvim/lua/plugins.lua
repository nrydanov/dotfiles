local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer = ensure_packer()

return require('packer').startup(function(use)
    -- Vim Package Manager
    use 'wbthomason/packer.nvim'
    -- LSP Package Manager
    use {
        {
            "williamboman/mason.nvim",
            opts = {
                ensure_installed = {
                    "mypy",
                    "ruff",
                    "pyright"
                }
            }
        },
        "williamboman/mason-lspconfig.nvim",
    }
    -- Native LSP configuration
    use {
        'neovim/nvim-lspconfig',
    }
    -- Completion
    use {
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline'
    }
    -- Fuzzy search
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    -- Non-LSP actions and more
    use {
        'nvimtools/none-ls.nvim',
    }
    -- LSP: Snippets
    use {
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
    }
    -- LSP signature pop-up
    use 'ray-x/lsp_signature.nvim'
    -- Syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    -- Pairing brackets
    use 'windwp/nvim-autopairs'
    -- Colorscheme colors retrieval
    use 'psliwka/termcolors.nvim'
    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'nvim-tree/nvim-web-devicons'
    }
    -- Git integration
    use 'lewis6991/gitsigns.nvim'
    -- Commenting
    use 'tpope/vim-commentary'
    -- File explorer
    use {
        "nvim-tree/nvim-tree.lua",
        after = "nvim-web-devicons",
        requires = "nvim-tree/nvim-web-devicons",
    } -- Colorscheme
    use 'nrydanov/one-nvim'
    use 'Mofiqul/vscode.nvim'
    use 'tjdevries/colorbuddy.vim'
    -- Misc
    use 'lukas-reineke/indent-blankline.nvim'
    use "kaarmu/typst.vim"
    use {
        'HallerPatrick/py_lsp.nvim',
        -- Support for versioning
        -- tag = "v0.0.1"
    }
    use {
        'NoahTheDuke/vim-just'
    }
    if packer then
        require('packer').sync()
    end
end)
