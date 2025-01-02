local function keybind(mode, key, action)
  -- convenience function
  vim.api.nvim_set_keymap(mode, key, action, { noremap = true, silent = true })
end

-- mapping leader function
keybind("", "<Space>", "<Nop>")

-- insert new lines, staying in normal mode
keybind("n", "<leader>o", "o<ESC>")
keybind("n", "<leader>O", "O<ESC>")

-- use emacs bindings in insert mode
keybind("i", "<C-A>", "<C-O>I")
keybind("i", "<C-E>", "<C-O>A")

-- paste in insert mode
keybind("i", "<C-V>", "<C-O>p")

-- directory navigation
keybind("n", "<leader>e", ":Explore<CR>")

-- cancel search highlight with esc
keybind("n", "<ESC>", ":noh<CR>")

-- tab to switch buffers in normal mode
keybind("n", "<Tab>", ":bnext<CR>")       -- next buffer
keybind("n", "<S-Tab>", ":bprevious<CR>") -- prev buffer

-- window splits
keybind("n", "<leader>s", ":wincmd s<CR>") -- split horizontally
keybind("n", "<leader>v", ":wincmd v<CR>") -- split vertically
keybind("n", "<leader>=", ":wincmd =<CR>") -- even out splits
keybind("n", "<leader>q", ":close<CR>")    -- close window split

-- navigating window splits
-- replaced by vim-tmux-navigator
--keybind("n", "<C-h>", ":wincmd h<CR>") -- focus left
--keybind("n", "<C-l>", ":wincmd l<CR>") -- focus right
--keybind("n", "<C-k>", ":wincmd k<CR>") -- focus up
--keybind("n", "<C-j>", ":wincmd j<CR>") -- focus down


-- maintain visual selection after changing indent
keybind("v", "<", "<gv")
keybind("v", ">", ">gv")

-- move selected blocks of text up/down
keybind("v", "<C-j>", ":m .+1<CR>==")
keybind("v", "<C-k>", ":m .-2<CR>==")
-- keybind("v", "p", '"_dP') -- not sure what this does? something with registers/pasting?

-- move text in visual block mode
keybind("x", "J", ":move '>+1<CR>gv-gv")
keybind("x", "K", ":move '<-2<CR>gv-gv")
keybind("x", "<C-j>", ":move '>+1<CR>gv-gv")
keybind("x", "<C-k>", ":move '<-2<CR>gv-gv")

-- sourcing/executing lua
keybind("n", "<space><space>x", "<cmd>source %<CR>")
keybind("n", "<space>x", ":.lua<CR>")
keybind("v", "<space>x", ":lua<CR>")


-- oil - TODO: set this up in oil config
vim.keymap.set("n", "<space><backspace>", "<cmd>Oil<CR>")

-- quickfix list
vim.keymap.set("n", "<C-u>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<C-i>", "<cmd>cprev<CR>")

-- LSP - these will be default keybinds in a future version
vim.keymap.set("n", "grn", vim.lsp.buf.rename)
vim.keymap.set("n", "gra", vim.lsp.buf.code_action)
vim.keymap.set("n", "grr", vim.lsp.buf.references)
vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help)
