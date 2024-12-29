-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
		"git", "clone",
		"--filter=blob:none",
		"--branch=stable",
        lazyrepo,
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keybinds")
require("config.theme")
require("config.autocommands")

local opts = {
	defaults = {
		lazy = true,
	},
	rtp = {
		disabled_plugins = {
			-- superceded by custom plugins
			"gzip",
			"matchit",
			"matchparen",
			"netrw",
			"netrwPlugin",
			"tarPlugin",
			"tohtml",
			"tutor",
			"zipPlugin",
		},
	},
	change_detection = {
		notify = true,
	},
}

require("lazy").setup("plugins", opts)
