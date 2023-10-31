local horizon = require('config.horizon_colours')
local mode_colours = {
    -- changes colour based on mode
    normal = horizon.orange,
    insert = horizon.dark_blue,
    terminal = horizon.green,
    replace = horizon.dark_blue,
    visual = horizon.pink,
    visual_selected = horizon.dull_pink,
    command = horizon.green,
}

local function theme(s)
    local ok, _ = pcall(vim.cmd, "colorscheme " .. s)
end

-- customising theme
vim.cmd("hi IndentBlankLineSpaceChar guifg="..horizon.grey)
vim.cmd("hi IndentBlankLineSpaceCharBlankline guifg="..horizon.grey)

vim.cmd("hi Cursor guifg=15 guibg="..mode_colours.normal)
vim.opt.guicursor = 'n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor'

vim.cmd("hi! link netrwMarkFile MatchParen")

vim.cmd("hi Visual guibg="..mode_colours.visual_selected)

vim.cmd("hi CursorLineNr guifg="..mode_colours.normal)
--vim.cmd("hi ColorColumn guibg=#4a2c33")
vim.cmd("hi ColorColumn guibg="..horizon.dark_orange)
