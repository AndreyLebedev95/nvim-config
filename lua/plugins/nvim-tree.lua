-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- optional
  { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
})

local config = {
  sync_root_with_cwd = true,
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  update_focused_file = { 
    enable = true
  },
}
require("nvim-tree").setup(config)
