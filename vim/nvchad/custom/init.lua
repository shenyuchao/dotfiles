-- This is an example init file , its supposed to be placed in /lua/custom/
-- This is where your custom modules and plugins go.
-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!
-- MAPPINGS
local map = require("core.utils").map

map("n", "<leader>cc", ":Telescope <CR>")
map("n", "<leader>q", ":q <CR>")

-- NOTE: the 4th argument in the map function can be a table i.e options but its most likely un-needed so dont worry about it

-- Install plugins
local customPlugins = require "core.customPlugins"

customPlugins.add(function(use)
    use {
        "p00f/nvim-ts-rainbow",
        event = "BufRead",
        after = "nvim-treesitter"
    }
    use {"williamboman/nvim-lsp-installer"}
    use {
        "mhartington/formatter.nvim",
        event = "VimEnter",
        config = function()
            require("custom.plugins.configs.formatter").setup()
        end
    }
    use {"onsails/lspkind-nvim"}
    use {
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
    }
end)