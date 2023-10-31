local settings = {
    termguicolors = true,
    cmdheight = 1,
    colorcolumn = '80',
    cursorline = true,
    showmode = false,
    completeopt = { "menuone", "noselect" },
    undofile = true,
    writebackup = false,
    autochdir = false,
    -- scroll before cusor reaches end
    scrolloff = 12,
    sidescrolloff = 4,
    -- 
    timeoutlen = 600, -- how long to wait for a command for combos (leader/etc)
    updatetime = 600, -- how long to wait until auto-save to a recovery file
    -- line number config
    number = true,
    numberwidth = 2,
    relativenumber = true,
    signcolumn = "yes",
    -- indent/tab settings
    expandtab = true, -- spaces > tabs
    autoindent = true,
    wrap = false,
    textwidth = 300,
    tabstop = 4,
    shiftwidth = 4,
    softtabstop = -1, -- if negative uses shiftwidth
    --
    list = true, -- show trailing whitespaces
    clipboard = 'unnamedplus', -- use OS clipboard
    history = 500, -- how many commands to keep in history
    -- split windows deterministically
    splitright = true,
    splitbelow = true,
}

vim.opt.shortmess:append "c"

for setting, value in pairs(settings) do
    vim.opt[setting] = value
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

vim.cmd "set showtabline=0"

