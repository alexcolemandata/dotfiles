local g = vim.g

local opts = { noremap = true, silent = true}

local function map(m, k, v)
    vim.api.nvim_set_keymap(m, k, v, opts)
end
-- Map <leader> to space
map("", "<Space>", "<Nop>")
g.mapleader = ' '
g.maplocalleader = ' '


-- inserting new lines, staying in normal mode
map('n', '<leader>o', 'o<ESC>')
map('n', '<leader>O', 'O<ESC>')


-- saving with ctrl+s
map('n', '<C-s>', ':w<CR>')

-- emacs in insert mode :D
map('i', '<C-A>', '<C-O>I')
map('i', '<C-E>', '<C-O>A')

-- paste in insert mode :D
map('i', '<C-V>', '<C-O>p')

-- explorer window
map('n', '<leader>e', ':Exp<CR>')

-- cancel search highlight with esc
map('n', '<ESC>', ':noh<CR>')

-- tab to switch buffers in normal mode
map('n', '<Tab>', ':bnext<CR>') -- next buffer
map('n', '<S-Tab>', ':bprevious<CR>') -- prev buffer

-- window splits
map('n', '<leader>s', ':wincmd s<CR>') -- split horizontally
map('n', '<leader>v', ':wincmd v<CR>') -- split vertically
map('n', '<leader>=', ':wincmd =<CR>') -- even out splits


map('n', '<leader>q', ':wincmd q<CR>') -- close window split
map('n', '<C-w>', ':Bdelete<CR>') -- close buffer - keep window open


-- easier navigating split windows
map('n', '<C-h>', ':wincmd h<CR>')
map('n', '<C-l>', ':wincmd l<CR>')
map('n', '<C-k>', ':wincmd k<CR>')
map('n', '<C-j>', ':wincmd j<CR>')

-- stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- move blocks of text
map("v", "<C-j>", ":m .+1<CR>==")
map("v", "<C-k>", ":m .-2<CR>==")
map("v", "p", '"_dP')


-- Visual Block --
-- Move text up and down
map("x", "J", ":move '>+1<CR>gv-gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "<C-j>", ":move '>+1<CR>gv-gv")
map("x", "<C-k>", ":move '<-2<CR>gv-gv")

-- Terminal --
-- Better terminal navigation
-- map_term("t", "<C-h>", "<C-\\><C-N><C-w>h")
-- map_term("t", "<C-j>", "<C-\\><C-N><C-w>j")
-- map_term("t", "<C-k>", "<C-\\><C-N><C-w>k")
-- map_term("t", "<C-l>", "<C-\\><C-N><C-w>l")

-- plugin specific remaps --
map("n", "<leader>,", ":Telescope buffers<CR>")
map("n", "<leader>/", ":Telescope <CR>")
map("n", "<leader><Return>", ":lua vim.lsp.buf.format( { async = true } )<CR>")

