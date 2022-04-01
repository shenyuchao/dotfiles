-- This is an example init file , its supposed to be placed in /lua/custom/
-- This is where your custom modules and plugins go.
-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!
-- MAPPINGS
local custom_modules = {"custom.autocmds"}

for _, module in ipairs(custom_modules) do
    local ok, err = pcall(require, module)
    if not ok then
        error("Error loading " .. module .. "\n\n" .. err)
    end
end
local map = require("core.utils").map

map("n", "<leader>cc", ":Telescope <CR>")
map("n", "<leader>q", ":q <CR>")
