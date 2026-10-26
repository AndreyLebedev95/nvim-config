vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- optional
	{ src = "http://github.com/ibhagwan/fzf-lua" },
})

vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "FZF live_grep" })
vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files({ line_query = true })
end, { desc = "FZF files" })
vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "FZF Help tags" })
vim.keymap.set("n", "<leader>fx", function()
	require("fzf-lua").diagnostics_document()
end, { desc = "FZF Diagnostics document" })
vim.keymap.set("n", "<leader>fs", function()
	require("fzf-lua").lsp_document_symbols()
end, { desc = "FZF lsp_document_symbols" })
vim.keymap.set("n", "<leader>fS", function()
	require("fzf-lua").lsp_workspace_symbols()
end, { desc = "FZF lsp_workspace_symbols" })
