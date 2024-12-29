return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup {
        ensure_installed = {
          "bash",
          "c",
          "python",
          "sql",
          "lua",
          "html",
          "csv",
          "json",
          "regex",
          "toml",
          "markdown",
          "vim",
          "vimdoc",
          "query",
          "markdown_inline",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
        },
        sync_install = false,
        modules = { },
        auto_install = false,
        ignore_install = { },
        indent = { enable = true },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end
  }
}
