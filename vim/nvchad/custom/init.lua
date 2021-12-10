-- This is an example init file , its supposed to be placed in /lua/custom dir
-- lua/custom/init.lua
-- This is where your custom modules and plugins go.
-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!
local hooks = require "core.hooks"

local custom_modules = {"custom.autocmds"}
for _, module in ipairs(custom_modules) do
    local ok, err = pcall(require, module)
    if not ok then
        error("Error loading " .. module .. "\n\n" .. err)
    end
end

-- MAPPINGS
-- To add new plugins, use the "setup_mappings" hook,

hooks.add("setup_mappings", function(map)
    map("n", "<leader>cc", ":Telescope <CR>", opt)
    map("n", "<leader>q", ":q <CR>", opt)
end)

-- NOTE : opt is a variable  there (most likely a table if you want multiple options),
-- you can remove it if you dont have any custom options

-- Install plugins
-- To add new plugins, use the "install_plugin" hook,

-- examples below:

hooks.add("install_plugins", function(use)
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

-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event' field)
-- see: https://github.com/wbthomason/packer.nvim
-- https://nvchad.github.io/config/walkthrough
