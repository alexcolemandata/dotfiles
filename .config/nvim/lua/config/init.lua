-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("config.globals")
require("config.options")
require("config.keybinds")
require("config.theme")
require("config.autocommands")

local opts = {
	defaults = {
		lazy = true,
	},
	install = {
		colorscheme = { "base16-horizon-terminal-dark" }
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
			"zipPlugin"
		},
	},
	change_detection = {
		notify = true,
	},
}

require("lazy").setup("plugins", opts)

-- TODO: moving to plugins directory, will delete
-- local plugins = {
    -- "nvim-lua/popup.nvim",
    -- "nvim-lua/plenary.nvim",
    -- "windwp/nvim-autopairs",
    -- "nvim-lualine/lualine.nvim",
    -- "kyazdani42/nvim-web-devicons",
    -- "moll/vim-bbye",
    -- "lukas-reineke/indent-blankline.nvim",
    -- "nvim-telescope/telescope.nvim",
    -- "tpope/vim-surround",
    -- "folke/which-key.nvim",
    -- "lewis6991/gitsigns.nvim",
    -- "RRethy/nvim-base16",
    -- "xiyaowong/nvim-transparent",
-- }
-- 
-- local opts = {}
-- 
-- require("lazy").setup(plugins, opts)
