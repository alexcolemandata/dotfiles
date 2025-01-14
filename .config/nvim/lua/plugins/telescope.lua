local setkey = vim.keymap.set


return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.4",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
      pickers = {
        find_files = {
          theme = "ivy",
          previewer = true,
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git*" }
        },
        live_grep = {
          theme = "ivy",
          previewer = true,
          hidden = true,
        },
        find_buffers = {
          theme = "ivy",
          previewer = true,
          hidden = true,
        }
      },
      extensions = {
        fzf = {},
        file_browser = {
          theme = "ivy",
          hijack_netrw = false,
        }
      }
    })

    require("telescope").load_extension("fzf")

    setkey("n", "<space>fh", require("telescope.builtin").help_tags)
    setkey("n", "<space>ff", require("telescope.builtin").find_files)
    setkey("n", "<space>fb", require("telescope.builtin").buffers)

    -- find files in nvim config
    setkey("n", "<space>en", function()
      require("telescope.builtin").find_files {
        cwd = vim.fn.stdpath("config")
      }
    end)

    -- find nvim packages
    setkey("n", "<space>ep", function()
      require("telescope.builtin").find_files {
        ---@diagnostic disable-next-line: param-type-mismatch
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
      }
    end)

    require "config.telescope.multigrep".setup()
  end
}
