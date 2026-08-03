vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.ai' },
	{ src = 'https://github.com/nvim-mini/mini.comment' },
	{ src = 'https://github.com/nvim-mini/mini.move' },
	{ src = 'https://github.com/nvim-mini/mini.surround' },
	{ src = 'https://github.com/nvim-mini/mini.cursorword' },
	{ src = 'https://github.com/nvim-mini/mini.indentscope' },
	{ src = 'https://github.com/nvim-mini/mini.pairs' },
	{ src = 'https://github.com/nvim-mini/mini.bufremove' },
	{ src = 'https://github.com/nvim-mini/mini.notify' },
	{ src = 'https://github.com/nvim-mini/mini.trailspace' },
})

require('mini.ai').setup()
require('mini.comment').setup()
require('mini.move').setup()
require('mini.surround').setup()
require('mini.cursorword').setup()
require('mini.indentscope').setup()
require('mini.pairs').setup()
require('mini.trailspace').setup()
require('mini.bufremove').setup()
-- require('mini.notify').setup()
