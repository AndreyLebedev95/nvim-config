vim.pack.add({{  src = 'https://github.com/folke/which-key.nvim'  }})

vim.keymap.set(
  "n",
  "<leader>?",
  function()
    require("which-key").show({ global = false })
  end,
  { desc = "Buffer Local Keymaps (which-key)" }
)

require('which-key').setup({
  filter = function(mapping)
    return not require('config.langmap').is_cyrillic(mapping.lhs)
  end,
})
