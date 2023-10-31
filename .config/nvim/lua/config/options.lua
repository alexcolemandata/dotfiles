local opt = vim.opt

-- Tabs/Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = -1 -- if negative uses shiftwidth
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
-- Appearance
opt.number = true
opt.relativenumber = true
opt.showmode = false
opt.numberwidth = 2
opt.list = true -- trailing white spaces
opt.termguicolors = true
opt.colorcolumn = '80'
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.cursorline = true
opt.scrolloff = 12
opt.sidescrolloff = 4
-- Behaviour
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true
opt.completeopt = "menuone,noinsert,noselect"
opt.backspace = "indent,eol,start"
opt.splitright = true
opt.splitbelow = true
opt.autochdir = false
opt.modifiable = true
opt.iskeyword:append("-")
opt.shortmess:append("c")
opt.clipboard:append("unnamedplus")
opt.encoding = "utf-8"
