-- Install plugins
return {{"williamboman/nvim-lsp-installer"}, {
    "p00f/nvim-ts-rainbow",
    event = "BufRead",
    after = "nvim-treesitter"
}, {"williamboman/nvim-lsp-installer"}, {
    "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function()
        require("custom.plugins.configs.null_ls").setup()
    end
}}
