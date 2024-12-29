return {
  {
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { 
          -- programming
          "bash",
          "c", 
          "python",
          "pip requirements",
          "sql",
          "lua", 
          -- data/misc
          "html",
          "csv",
          "json",
          "toml",
          "markdown", 
          -- vim
          "vim", 
          "vimdoc", 
          "query", 
          "markdown_inline",
          -- git
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
        },
        auto_install = false,
        highlight = {
          enable = true,
          disable = function(lang, buf)
            -- disable treesitter for files over 100KB
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end
        },
        additional_vim_regex_highlighting = false,
      }
    end,
  }
}
