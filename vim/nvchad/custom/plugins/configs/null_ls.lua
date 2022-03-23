local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
   b.formatting.autopep8,
   b.formatting.clang_format,
   b.formatting.cmake_format,
   b.formatting.codespell,
   b.formatting.crystal_format,
   b.formatting.deno_fmt,
   b.formatting.djlint,
   b.formatting.eslint_d,
   b.formatting.fixjson,
   b.formatting.gofumpt,
   b.formatting.golines,
   b.formatting.lua_format,
   b.formatting.nginx_beautifier,
   b.formatting.phpcsfixer,
   b.formatting.prettierd,
   b.formatting.stylua,
   b.formatting.shfmt,
   b.diagnostics.golangci_lint,
   b.diagnostics.codespell,
   b.diagnostics.cppcheck,
   b.diagnostics.protoc_gen_lint,
   b.diagnostics.shellcheck,
   b.diagnostics.phpcs,
   b.diagnostics.eslint,
   b.code_actions.shellcheck,
   b.hover.dictionary,
}

local M = {}

M.setup = function()
   null_ls.setup {
      debug = true,
      sources = sources,

      -- format on save
      on_attach = function(client)
         if client.resolved_capabilities.document_formatting then
            vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
         end
      end,
   }
end

return M