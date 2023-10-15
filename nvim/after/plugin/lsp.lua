require "lsp_signature".setup {}

local lsp = require "lspconfig"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
}

local servers = { "clangd", "gopls", "pylsp", 'intelephense' }

local settings = {
    pylsp = {
        {}
    }
}

for _, server in ipairs(servers) do
    lsp[server].setup({ capabilities = capabilities, settings = settings[server] })
end

local cmp = require "cmp"
local luasnip = require "luasnip"

require "luasnip.loaders.from_vscode".load {}

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


luasnip.config.set_config({ history = true, updateevents = "TextChanged,TextChangedI" })

cmp.setup({
    mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Up>"] = cmp.mapping.select_prev_item(),
        ["<Down>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    sources = { { name = "nvim_lsp" }, { name = "luasnip" } },
    completion = { completeopt = "menu,menuone,noinsert" },
    experimental = { ghost_text = true },
})
