-- This is where your custom modules and plugins go.
-- See the wiki for a guide on how to extend NvChad
local custom_modules = {"custom.autocmds"}

local hooks = require "core.hooks"

for _, module in ipairs(custom_modules) do
    local ok, err = pcall(require, module)
    if not ok then
        error("Error loading " .. module .. "\n\n" .. err)
    end
end

-- NOTE: To use this, make a copy with `cp example_init.lua init.lua`

--------------------------------------------------------------------

-- To modify packaged plugin configs, use the overrides functionality
-- if the override does not exist in the plugin config, make or request a PR,
-- or you can override the whole plugin config with 'chadrc' -> M.plugins.default_plugin_config_replace{}
-- this will run your config instead of the NvChad config for the given plugin

-- hooks.override("lsp", "publish_diagnostics", function(current)
--   current.virtual_text = false;
--   return current;
-- end)

-- To add new mappings, use the "setup_mappings" hook,
-- you can set one or many mappings
-- example below:

-- hooks.add("setup_mappings", function(map)
--    map("n", "<leader>cc", "gg0vG$d", opt) -- example to delete the buffer
--    .... many more mappings ....
-- end)

-- To add new plugins, use the "install_plugin" hook,
-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event' field)
-- see: https://github.com/wbthomason/packer.nvim
-- examples below:

-- hooks.add("install_plugins", function(use)
--    use {
--       "max397574/better-escape.nvim",
--       event = "InsertEnter",
--    }
-- end)

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
    -- use {
    --     "jose-elias-alvarez/null-ls.nvim",
    --     requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"},
    --     after = "nvim-lspconfig",
    --     config = function()
    --         require("custom.plugins.configs.null_ls").setup()
    --     end
    -- }
end)

-- alternatively, put this in a sub-folder like "lua/custom/plugins/mkdir"
-- then source it with

-- require "custom.plugins.mkdir"

-- vim global variables
vim.g.python_host_prog = "$PYENV_ROOT/versions/neovim2/bin/python"
vim.g.python3_host_prog = "$PYENV_ROOT/versions/neovim3/bin/python"
