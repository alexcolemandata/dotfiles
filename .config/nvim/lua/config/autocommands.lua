vim.cmd([[
    augroup _general_settings
        autocmd!
        autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
        autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
        autocmd BufWinEnter * :set formatoptions-=cro
        autocmd FileType qf set nobuflisted
    augroup end

    augroup _auto_resize
        autocmd!
        autocmd VimResized * tabdo wincmd =
    augroup end
]])

-- change cursor colours on mode switch
local horizon = require("ac.horizon_colours")
local mode_colours = {
	normal = horizon.orange,
	insert = horizon.dark_blue,
	terminal = horizon.green,
	replace = horizon.dark_blue,
	visual = horizon.pink,
	visual_selected = horizon.dull_pink,
	command = horizon.green,
}

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

