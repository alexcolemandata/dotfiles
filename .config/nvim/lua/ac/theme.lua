-- COLORSCHEMES
local function theme(s)
    local ok, _ = pcall(vim.cmd, 'colorscheme '..s)
end

theme('base16-horizon-terminal-dark')

-- customising themes
vim.cmd("hi IndentBlankLineSpaceChar guifg=#6f6f70")
vim.cmd("hi IndentBlankLineSpaceCharBlankline guifg=#6f6f70")

-- custom cursor colour
-- horizon colours:
local mode_colours = require('ac.mode_colours')

vim.cmd("hi Cursor guifg=15 guibg="..mode_colours.normal)
vim.opt.guicursor = 'n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor'

vim.cmd("hi! link netrwMarkFile MatchParen")

vim.cmd("hi Visual guibg="..mode_colours.visual_selected)

vim.cmd("hi CursorLineNr guifg="..mode_colours.normal)
