-- Install plugins
return {
    {
        "p00f/nvim-ts-rainbow",
        event = "BufRead",
        after = "nvim-treesitter"
    },
    {"williamboman/nvim-lsp-installer"},
    {
        "mhartington/formatter.nvim",
        event = "VimEnter",
        config = function()
            require("custom.plugins.configs.formatter").setup()
        end
    },
    {"onsails/lspkind-nvim"},
    {
        'tzachar/cmp-tabnine',
        run = './install.sh',
        after = "nvim-cmp",
        config = function()
            local tabnine = require('cmp_tabnine.config')
            tabnine:setup({
                max_lines = 1000,
                max_num_results = 20,
                sort = true,
                run_on_every_keystroke = true,
                snippet_placeholder = '..'
            })
        end
    },
}