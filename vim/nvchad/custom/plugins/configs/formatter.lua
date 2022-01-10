local M = {}

M.setup = function()
    require("formatter").setup({
        filetype = {
            javascript = { -- prettier
            function()
                return {
                    exe = "prettier",
                    args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote'},
                    stdin = true
                }
            end},
            lua = {function()
                return {
                    exe = "stylua",
                    args = {"--config-path " .. os.getenv("HOME") .. "/.stylua.toml", "-"},
                    stdin = true
                }
            end},
            rust = { -- Rustfmt
            function()
                return {
                    exe = "rustfmt",
                    args = {"--emit=stdout"},
                    stdin = true
                }
            end},
            sh = { -- Shell Script Formatter
            function()
                return {
                    exe = "shfmt",
                    args = {"-i", 2},
                    stdin = true
                }
            end},
            cpp = { -- clang-format
            function()
                return {
                    exe = "clang-format",
                    args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
                    stdin = true,
                    cwd = vim.fn.expand('%:p:h') -- Run clang-format in cwd of the file.
                }
            end},
            python = {function()
                return {
                    exe = "python3 -m autopep8",
                    args = {"--in-place --aggressive --aggressive", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
                    stdin = false
                }
            end},
            go = {function()
                return {
                    exe = "gofmt",
                    args = {" -w ", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
                    stdin = false
                }
            end, function()
                return {
                    exe = "gofumpt",
                    args = {" -l -w ", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
                    stdin = false
                }
            end}
        }
    })
end

return M
