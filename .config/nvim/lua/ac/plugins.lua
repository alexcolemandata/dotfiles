-- Packer Bootstrap
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
      'git', 
      'clone', 
      '--depth', 
      '1', 
      'https://github.com/wbthomason/packer.nvim', 
      install_path,
  })

  print("Installing packer - close and reopen Neovim")
  vim.cmd [[packadd packer.nvim]]
end

-- reload neovim/install packer whenever i save this file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- use protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    vim.notify("protected call for packer failed - you might need to reinstall packer")
    return
end


-- use pop-up window for packer
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Packer Addons
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- packer manages iteslf
  use 'nvim-lua/popup.nvim' -- popup api
  use 'nvim-lua/plenary.nvim' -- extensions used by lots of plugins
  use 'windwp/nvim-autopairs'
  use 'nvim-lualine/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'moll/vim-bbye'
  use 'goolord/alpha-nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.0' }

  use 'xiyaowong/nvim-transparent'

  -- Tim Pope Plugins --
  use 'tpope/vim-surround'
  -- Syntax Highlighting and Colors --
  -- use 'vim-python/python-syntax'
  -- use 'ap/vim-css-color'

  -- Docstrings
  use 'danymat/neogen'

  -- Colorschemes
  use 'RRethy/nvim-base16'

  -- indentation guide
  -- LSP goodness
  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim" -- simple to use language server installer
  use "williamboman/mason-lspconfig.nvim" -- simple to use language server installer
  use "jose-elias-alvarez/null-ls.nvim"
  use "RRethy/vim-illuminate"

  -- coding helpers
  use "Vimjas/vim-python-pep8-indent"

  -- completion system
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"

  -- snipping engine
  use "L3MON4D3/LuaSnip"

  use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
          local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
          ts_update()
      end,
  }

  use { "lewis6991/gitsigns.nvim" }

  -- automatically set up config/install plugins if just installed packer
  if packer_bootstrap then
    require('packer').sync()
  end

end)
