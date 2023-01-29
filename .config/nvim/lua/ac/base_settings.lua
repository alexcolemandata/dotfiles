print("loading base settings")

local settings = {
    -- general ui stuff
    termguicolors = true,
    cmdheight = 1,
    cursorline = true,
    showmode = false, -- mode is shown with lualine
    --completeopt = { "menuone", "noselect" },
    undofile = true,
    writebackup = false,
    autochdir = false,
    -- scroll before cursor reaches the end
    scrolloff = 12,
    sidescrolloff = 4,
    --
    timeoutlen = 600, -- how long to wait for a command for combos
    updatetime = 600, -- how long to wait until auto-save to a recovery file
    -- line number config
    number = true,
    numberwidth = 2,
    relativenumber = true,
    signcolumn = 'yes',
    -- indent/tab settings
    expandtab = true,
    autoindent = true,
    wrap = false,
    textwidth = 300,
    tabstop = 4,
    shiftwidth = 4,
    softtabstop = -1, -- If negative, shiftwidth value is used
    -- 
    list = true,  -- controls how tabs/trailing spaces are displayed in different modes
    clipboard = 'unnamedplus', -- use OS Clipboard
    history = 500, -- how many commands to keep in history
    -- split deterministicaly    
    splitright = true,
    splitbelow = true,
    -- 
    --mouse = "a", -- enable mouse

}

vim.opt.shortmess:append "c"

for setting, value in pairs(settings) do
    vim.opt[setting] = value
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

vim.cmd "set showtabline=0"
