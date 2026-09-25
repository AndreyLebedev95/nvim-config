-- ================================================================================================
-- TITLE : Russian layout support
-- ABOUT : 'langmap' covers built-in commands; mappings are duplicated with Cyrillic lhs because
--         'langmap' translates only the first key of a mapping
-- ================================================================================================

local M = {}

local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm,.~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>#]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ№]]

local to_ru = {}
local ru_chars = vim.fn.split(ru, "\\zs")
for i = 1, #en do
	to_ru[en:sub(i, i)] = ru_chars[i]
end

local function escape(s)
	return (s:gsub("[;,\\]", "\\%0"))
end

local pairs_list = {}
for i = 1, #en do
	table.insert(pairs_list, escape(ru_chars[i]) .. escape(en:sub(i, i)))
end
vim.opt.langmap = table.concat(pairs_list, ",")

local function translate(lhs)
	local out, i, changed = {}, 1, false
	while i <= #lhs do
		local special = lhs:match("^<[^<>]+>", i)
		if special then
			table.insert(out, special)
			i = i + #special
		else
			local ch = lhs:sub(i, i)
			local tr = to_ru[ch]
			if tr then
				changed = true
			end
			table.insert(out, tr or ch)
			i = i + 1
		end
	end
	return changed and table.concat(out) or nil
end

M.translate = translate

local modes = { "n", "x", "o" }

local function is_duplicable(map)
	if map.lhs:find("^<Plug>") or map.lhs:find("^<SNR>") then
		return false
	end
	if map.desc and map.desc:find("which-key-trigger", 1, true) then
		return false
	end
	return (map.rhs and map.rhs ~= "") or map.callback ~= nil
end

local function mirror(maps, mode, buf)
	local existing = {}
	for _, map in ipairs(maps) do
		existing[map.lhs] = true
	end
	for _, map in ipairs(maps) do
		local lhs = is_duplicable(map) and translate(map.lhs)
		if lhs and not existing[lhs] then
			existing[lhs] = true
			vim.keymap.set(mode, lhs, map.callback or map.rhs, {
				buffer = buf,
				remap = map.noremap == 0,
				expr = map.expr == 1,
				silent = map.silent == 1,
				nowait = map.nowait == 1,
				script = map.script == 1,
				replace_keycodes = map.replace_keycodes == 1,
				desc = map.desc,
			})
		end
	end
end

function M.sync(buf)
	for _, mode in ipairs(modes) do
		mirror(vim.api.nvim_get_keymap(mode), mode)
		if buf and vim.api.nvim_buf_is_valid(buf) then
			mirror(vim.api.nvim_buf_get_keymap(buf, mode), mode, buf)
		end
	end
end

function M.is_cyrillic(lhs)
	return lhs ~= nil and (lhs:find("[\208\209]") ~= nil or lhs:find("№", 1, true) ~= nil)
end

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "FileType", "LspAttach" }, {
	group = vim.api.nvim_create_augroup("RussianLangmap", { clear = true }),
	callback = function(ev)
		vim.schedule(function()
			M.sync(ev.buf)
		end)
	end,
})

return M
