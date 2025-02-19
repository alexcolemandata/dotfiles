vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


vim.cmd([[
    augroup _general_settings
        autocmd!
        autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
        autocmd BufWinEnter * :set formatoptions-=cro
        autocmd FileType qf set nobuflisted
    augroup end

    augroup _auto_resize
        autocmd!
        autocmd VimResized * tabdo wincmd =
    augroup end
]])

-- change cursor colours on mode switch
-- TODO: pull this from base16 directly + remove horizon_colours
local colors = require("config.theme_colours")

local mode_colours = {
  normal = colors.orange,
  insert = colors.dark_blue,
  terminal = colors.green,
  replace = colors.dark_blue,
  visual = colors.pink,
  visual_selected = colors.dull_pink,
  command = colors.green,
}

-- dynamically changing colours based on mode
vim.cmd(string.format(
  [[
    augroup _cursor_dynamic_insert
        autocmd!
        autocmd InsertEnter * :hi Cursor guibg=%s
        autocmd InsertEnter * :hi CursorLineNr guifg=%s
        autocmd InsertLeave * :hi Cursor guibg=%s
        autocmd InsertLeave * :hi CursorLineNr guifg=%s
    augroup end
]],
  mode_colours.insert,
  mode_colours.insert,
  mode_colours.normal,
  mode_colours.normal
))

vim.cmd(string.format(
  [[
    augroup _cursor_dynamic_visual
        autocmd!
        autocmd ModeChanged *:[vV\x16] :hi Cursor guibg=%s
        autocmd ModeChanged *:[vV\x16] :hi CursorLineNr guifg=%s
        autocmd ModeChanged [vV\x16]:* :hi Cursor guibg=%s
        autocmd ModeChanged [vV\x16]:* :hi CursorLineNr guifg=%s
    augroup end
]],
  mode_colours.visual,
  mode_colours.visual,
  mode_colours.normal,
  mode_colours.normal
))

vim.cmd(string.format(
  [[
    augroup _cursor_dynamic_command autocmd!
        autocmd CmdLineEnter * :hi Cursor guibg=%s
        autocmd CmdLineLeave * :hi Cursor guibg=%s
    augroup end
]],
  mode_colours.command,
  mode_colours.normal
))

vim.cmd(string.format(
  [[
    augroup _cursor_dynamic_terminal autocmd!
        autocmd TermEnter * :hi Cursor guibg=%s
        autocmd TermLeave * :hi Cursor guibg=%s
    augroup end
]],
  mode_colours.command,
  mode_colours.terminal
))
