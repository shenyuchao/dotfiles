-- This is an example init file , its supposed to be placed in /lua/custom/
-- This is where your custom modules and plugins go.
-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!
-- MAPPINGS
local map = require("core.utils").map

map("n", "<leader>cc", ":Telescope <CR>")
map("n", "<leader>q", ":q <CR>")