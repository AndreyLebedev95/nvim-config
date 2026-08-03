local M = {}

M.on_attach = function(event)
	if not event.data then
		return
	end

	local client = vim.lsp.get_client_by_id(event.data.client_id)

	if not client then
		return
	end
	local bufnr = event.buf
	local keymap = function(mode, key, action, desc)
		local opts = {
			noremap = true, -- prevent recursive mapping
			silent = true, -- don't print the command to the cli
			buffer = bufnr, -- restrict the keymap to the local buffer number
			desc = desc,
		}

		vim.keymap.set(mode, key, action, opts)
	end

	-- native neovim keymaps
	keymap("n", "<leader>gd", vim.lsp.buf.definition, "Goto definition")
	keymap("n", "<leader>gD", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, "Goto definition (vertical split)")
	keymap("n", "<leader>ca", vim.lsp.buf.code_action, "Code actions")
	keymap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	keymap("n", "<leader>D", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, "Line diagnostics (float)")
	keymap("n", "<leader>d", function()
		vim.diagnostic.open_float()
	end, "Cursor diagnostics")
	keymap("n", "<leader>pd", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, "Previous diagnostic")
	keymap("n", "<leader>nd", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, "Next diagnostic")
	keymap("n", "K", vim.lsp.buf.hover, "Hover documentation")

	-- fzf-lua keymaps
	keymap("n", "<leader>fd", "<cmd>FzfLua lsp_finder<CR>", "LSP finder (definitions + references)")
	keymap("n", "<leader>fr", "<cmd>FzfLua lsp_references<CR>", "References to symbol under cursor")
	keymap("n", "<leader>ft", "<cmd>FzfLua lsp_typedefs<CR>", "Type definition of symbol under cursor")
	keymap("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>", "Symbols in current file")
	keymap("n", "<leader>fw", "<cmd>FzfLua lsp_workspace_symbols<CR>", "Symbols across workspace")
	keymap("n", "<leader>fi", "<cmd>FzfLua lsp_implementations<CR>", "Goto implementation")

	-- Order Imports (if supported by the client LSP)
	if client:supports_method("textDocument/codeAction", bufnr) then
		keymap("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = {
					only = { "source.organizeImports" },
					diagnostics = {},
				},
				apply = true,
				bufnr = bufnr,
			})
			-- format after changing import order
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50) -- slight delay to allow for the import order to go first
		end, "Organize imports")
	end

	-- === DAP keymaps ===
	local dap_ok, dap = pcall(require, "dap")
	if dap_ok and client.name == "rust-analyzer" then -- debugging only configured for Rust
		keymap("n", "<leader>dc", dap.continue, "DAP: continue / start")
		keymap("n", "<leader>do", dap.step_over, "DAP: step over")
		keymap("n", "<leader>di", dap.step_into, "DAP: step into")
		keymap("n", "<leader>du", dap.step_out, "DAP: step out")
		keymap("n", "<leader>db", dap.toggle_breakpoint, "DAP: toggle breakpoint")
		keymap("n", "<leader>dr", dap.repl.open, "DAP: open REPL")
	end
end

return M
