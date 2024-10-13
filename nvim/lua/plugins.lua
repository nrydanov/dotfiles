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
    use 'numirias/semshi'
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
            },
        },
        "williamboman/mason-lspconfig.nvim",
    }
    -- Native LSP configuration
    use {
        'neovim/nvim-lspconfig',
    }
    -- Completion
    use {
        'ms-jpq/coq_nvim',
        'ms-jpq/coq.artifacts'
    }

    -- Fuzzy search
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        -- or                            , branch = '0.1.x',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    -- LSP signature pop-up
    use 'ray-x/lsp_signature.nvim'
    -- Syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    }
    -- Pairing brackets
    use 'windwp/nvim-autopairs'
    -- Colorscheme colors retrieval
    use 'psliwka/termcolors.nvim'
    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'nvim-tree/nvim-web-devicons',
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
    }
    -- Colorscheme
    use 'nrydanov/one-nvim'
    use 'tjdevries/colorbuddy.vim'
    use {
        'sonph/onehalf',
        rtp = "vim"
    }
    -- Misc
    use 'lukas-reineke/indent-blankline.nvim'
    use "kaarmu/typst.vim"
    use { "linux-cultist/venv-selector.nvim", branch = 'regexp' }
    use { 'akinsho/git-conflict.nvim', tag = "*" }
    use {
        "j-hui/fidget.nvim",
    }
    use "milanglacier/yarepl.nvim"
    use 'RRethy/vim-illuminate'
    use { 'supermaven-inc/supermaven-nvim', commit = "40bde487fe31723cdd180843b182f70c6a991226", }
    use { 'https://github.com/apple/pkl-neovim',
        after = "nvim-treesitter",
        run = ":TSInstall! pkl" } -- Pkl syntax highlighting
    use 'dstein64/vim-startuptime'
    if packer then
        require('packer').sync()
    end
    use 'psliwka/vim-smoothie'

    use 'ray-x/go.nvim'
    use 'ray-x/guihua.lua'
end)
