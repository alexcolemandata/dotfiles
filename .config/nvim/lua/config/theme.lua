local M = {}
local colors = require("base16-colorscheme").colors
local mode_colours = {
  -- changes colour based on mode
  normal = colors.base08,
  insert = colors.base09,
  terminal = colors.base0A,
  replace = colors.base0B,
  visual = colors.base0C,
  visual_selected = colors.base0D,
  command = colors.base0F,
}

-- customising theme
vim.cmd("hi IndentBlankLineSpaceChar guifg=" .. colors.base02)
vim.cmd("hi IndentBlankLineSpaceCharBlankline guifg=" .. colors.base02)

vim.cmd("hi Cursor guifg=15 guibg=" .. mode_colours.normal)
vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"

vim.cmd("hi! link netrwMarkFile MatchParen")

vim.cmd("hi Visual guibg=" .. mode_colours.visual_selected)

vim.cmd("hi CursorLineNr guifg=" .. mode_colours.normal)
--vim.cmd("hi ColorColumn guibg=#4a2c33")
vim.cmd("hi ColorColumn guibg=" .. colors.base01)

M.mode_colours = mode_colours

return M
