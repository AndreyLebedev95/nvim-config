-- ================================================================================================
-- TITLE : luacheck config
-- ABOUT : teaches luacheck about the Neovim runtime so it stops flagging `vim` as undefined
-- LINKS :
--   > docs : https://luacheck.readthedocs.io/en/stable/config.html
-- ================================================================================================

-- LuaJIT is what Neovim embeds
std = "luajit"

-- `vim` is writable: config code assigns to vim.g / vim.opt / vim.o fields.
-- Using `globals` rather than `read_globals` avoids W122 on those assignments.
globals = { "vim" }

-- Neovim's LSP/plugin callbacks routinely take args they don't use
unused_args = false

-- Don't lint downloaded plugin source
exclude_files = { "pack/" }
