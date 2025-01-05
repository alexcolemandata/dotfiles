local config = function()
  local mode_colors = require("config.theme").mode_colours
  local colors = require("base16-colorscheme").colors

  local base_bg = colors.base00
  local base_inactive_fg = colors.base01
  local base_active_primary_fg = colors.base02
  local base_active_secondary_fg = colors.base03

  local buffer_opts = {
    "buffers",
    show_filename_only = false,
    icons_enabled = false,
    --max_length = vim.o.columns * 4 / 5,
    mode = 0,
    buffers_color = {
      active = { fg = colors.base0A, gui = 'bold' }
    },
    symbols = {
      modified = ' ●', -- Text to show when the buffer is modified
      alternate_file = '', -- Text to show to identify the alternate file
      directory = '', -- Text to show when the buffer is a directory
    },
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  }

  local theme = function()
    return {
      inactive = {
        a = { fg = base_inactive_fg, bg = nil },
        b = { fg = base_inactive_fg, bg = nil },
        c = { fg = base_inactive_fg, bg = base_bg },
      },
      terminal = {
        a = { fg = base_active_primary_fg, bg = mode_colors.terminal, gui = "bold" },
        b = { fg = base_active_secondary_fg, bg = base_bg },
        c = { fg = base_active_secondary_fg, bg = base_bg },
      },
      visual = {
        a = { fg = base_active_primary_fg, bg = mode_colors.visual, gui = "bold" },
        b = { fg = base_active_secondary_fg, bg = base_bg },
        c = { fg = base_active_secondary_fg, bg = base_bg },
      },
      replace = {
        a = { fg = base_active_primary_fg, bg = mode_colors.replace, gui = "bold" },
        b = { fg = base_active_secondary_fg, bg = base_bg },
        c = { fg = base_active_secondary_fg, bg = base_bg },
      },
      normal = {
        a = { fg = base_active_primary_fg, bg = mode_colors.normal, gui = "bold" },
        b = { fg = base_active_secondary_fg, bg = base_bg },
        c = { fg = base_active_secondary_fg, bg = base_bg },
      },
      insert = {
        a = { fg = base_active_primary_fg, bg = mode_colors.insert, gui = "bold" },
        b = { fg = base_active_secondary_fg, bg = base_bg },
        c = { fg = base_active_secondary_fg, bg = base_bg },
      },
      command = {
        a = { fg = base_active_primary_fg, bg = mode_colors.command, gui = "bold" },
        b = { fg = base_active_secondary_fg, bg = base_bg },
        c = { fg = base_active_secondary_fg, bg = base_bg },
      },
    }
  end

  require("lualine").setup {
    options = {
      theme = theme,
      icons_enabled = true,
      globalstatus = false,
      always_divide_middle = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = {
        'mode'
      },
      lualine_b = { "diff" },
      lualine_c = {},
      lualine_x = { buffer_opts },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  }
end

return {
  "nvim-lualine/lualine.nvim",
  enabled = false,
  dependencies = {
    "RRethy/nvim-base16"
  },
  lazy = false,
  config = config,
}
