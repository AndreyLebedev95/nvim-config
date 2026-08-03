vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
})

require('nvim-treesitter').install ({ 'bash', 'json', 'markdown', 'javascript', 'typescript', 'scss', 'css', 'html' })

require('nvim-treesitter').setup ({
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/nvim-treesitter',
  highlight = {
    enable = true,
    additional_vim_regex_higlight = false,
  },
  indent = { enable = true }, 
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tsx', 'ts', 'js', 'css', 'scss', 'hmtl' },
  callback = function() vim.treesitter.start() end,
})

