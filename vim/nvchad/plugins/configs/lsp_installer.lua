local M = {}

M.setup_lsp = function(attach, capabilities)
    local lsp_installer = require "nvim-lsp-installer"

    lsp_installer.on_server_ready(function(server)
        local opts = {
            on_attach = function (client, bufnr)
                local function buf_set_keymap(...)
                    vim.api.nvim_buf_set_keymap(bufnr, ...)
                 end
                 local function buf_set_option(...)
                    vim.api.nvim_buf_set_option(bufnr, ...)
                 end
                 attach(client, bufnr)
              
                 -- Enable completion triggered by <c-x><c-o>
                 buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
              
                 -- Mappings.
                 local opts = { noremap = true, silent = true }
              
                 -- See `:help vim.lsp.*` for documentation on any of the below functions
                 buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
                 buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
                 buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
                 buf_set_keymap("n", "gi", "<cmd>nlua vim.lsp.buf.implementation()<CR>", opts)
                 buf_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
                 buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
                 buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
                 buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
                 buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
                 buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
                 buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
                 buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
                 buf_set_keymap("n", "ge", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
                 buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
                 buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
                 buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
                 buf_set_keymap("n", "<space>fm", "<cmd>Format<CR>", opts)
                 buf_set_keymap("v", "<space>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
            end,
            capabilities = capabilities,
            flags = {
                debounce_text_changes = 150
            },
            settings = {}
        }

        if server.name == "rust_analyzer" then
            opts.settings = {
                ["rust-analyzer"] = {
                    experimental = {
                        procAttrMacros = true
                    }
                }
            }

            opts.on_attach = function(client, bufnr)
                local function buf_set_keymap(...)
                    vim.api.nvim_buf_set_keymap(bufnr, ...)
                end

                -- Run nvchad's attach
                attach(client, bufnr)

                -- Use nvim-code-action-menu for code actions for rust
                buf_set_keymap(bufnr, "n", "<leader>ca", "lua vim.lsp.buf.range_code_action()<CR>", {
                    noremap = true,
                    silent = true
                })
                buf_set_keymap(bufnr, "v", "<leader>ca", "lua vim.lsp.buf.range_code_action()<CR>", {
                    noremap = true,
                    silent = true
                })
            end
        end

        server:setup(opts)
        --   vim.cmd [[ do User LspAttachBuffers ]]
    end)
end

return M
