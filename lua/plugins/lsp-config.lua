vim.pack.add({
	{ src = "https://github.com/creativenull/efmls-configs-nvim" }, -- Preconfigured EFM Language Server setups
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" }, -- nvim-cmp source for LSP-based completion
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

require("mason").setup()
require("servers")
require("utils.diagnostics").setup()
