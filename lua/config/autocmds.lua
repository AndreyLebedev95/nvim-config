-- ================================================================================================
-- TITLE : auto-commands
-- ABOUT : automatically run code on defined events (e.g. save, yank)
-- ================================================================================================
local on_attach = require("utils.lsp").on_attach

-- Restore last cursor position when reopening a file
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", {})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = last_cursor_group,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Highlight the yanked text for 200ms
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 400,
		})
	end,
})

-- repos whose own style conflicts with the configured formatters
local format_on_save_exclude = {
	vim.fs.normalize("~/Desktop/work/backend"),
}

local function is_format_excluded(bufnr)
	local path = vim.api.nvim_buf_get_name(bufnr)
	if path == "" then
		return false
	end
	path = vim.fs.normalize(path)
	for _, root in ipairs(format_on_save_exclude) do
		if path == root or vim.startswith(path, root .. "/") then
			return true
		end
	end
	return false
end

-- format on save using efm langserver and configured formatters
local lsp_fmt_group = vim.api.nvim_create_augroup("FormatOnSaveGroup", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = lsp_fmt_group,
	callback = function(args)
		if is_format_excluded(args.buf) then
			return
		end
		require("mini.trailspace").trim()
		local efm = vim.lsp.get_clients({ name = "efm" })
		if vim.tbl_isempty(efm) then
			return
		end
		vim.lsp.buf.format({ name = "efm", async = true })
	end,
})

-- on attach function shortcuts
local lsp_on_attach_group = vim.api.nvim_create_augroup("LspMappings", {})
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_on_attach_group,
	callback = on_attach,
})

-- custom options for text/markdown files
local markdown_options = vim.api.nvim_create_augroup("MardownOptions", {})
vim.api.nvim_create_autocmd("FileType", {
	group = markdown_options,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
		vim.opt_local.cursorline = false
		vim.opt_local.colorcolumn = ""
	end,
})

-- follow [text](path.md#anchor) under cursor: opens path relative to the file, jumps to <a id="anchor">
local function follow_md_link()
	local line, col = vim.api.nvim_get_current_line(), vim.fn.col(".")
	local target
	for s, t, e in line:gmatch("()%[.-%]%((.-)%)()") do
		if col >= s and col < e then
			target = t
			break
		end
	end
	if not target then
		return vim.cmd("normal! gf")
	end
	local path, anchor = target:match("^([^#]*)#?(.*)$")
	vim.cmd("normal! m'")
	if path ~= "" then
		vim.cmd.edit(vim.fn.fnameescape(vim.fs.joinpath(vim.fn.expand("%:p:h"), path)))
	end
	if anchor ~= "" and vim.fn.search('\\V<a id="' .. anchor .. '"', "cw") == 0 then
		vim.notify("anchor not found: " .. anchor, vim.log.levels.WARN)
	end
end

local markdown_links = vim.api.nvim_create_augroup("MarkdownLinks", {})
vim.api.nvim_create_autocmd("FileType", {
	group = markdown_links,
	pattern = "markdown",
	callback = function(ev)
		vim.keymap.set("n", "gf", follow_md_link, { buffer = ev.buf, desc = "Follow markdown link" })
	end,
})
