
local horizon = require("config.horizon_colours")

local base_bg = horizon.dark_grey
local base_inactive_fg = horizon.grey
local base_active_primary_fg = horizon.darker_grey
local base_active_secondary_fg = horizon.lightest_grey

local buffer_opts = {
    "buffers",
    icons_enabled = false,
    --max_length = vim.o.columns * 4 / 5,
    mode = 0,
    buffers_color = {
      active = { fg = horizon.blue, gui='bold'}
    },
    symbols = {
      modified = ' ●',      -- Text to show when the buffer is modified
      alternate_file = '', -- Text to show to identify the alternate file
      directory = '',     -- Text to show when the buffer is a directory
    },
    section_separators = { left = '', right = ''},
    component_separators = { left = '', right = ''},
}

local config = function()
    local theme = function()
        return {
            inactive = {
                a = { fg = base_inactive_fg, bg = nil },
                b = { fg = base_inactive_fg, bg = nil },
                c = { fg = base_inactive_fg, bg = base_bg },
            },
            terminal = {
                a = { fg = base_active_primary_fg, bg = horizon.green, gui = "bold" },
                b = { fg = base_active_secondary_fg, bg = base_bg },
                c = { fg = base_active_secondary_fg, bg = base_bg },
            },
            visual = {
                a = { fg = base_active_primary_fg, bg = horizon.pink, gui = "bold" },
                b = { fg = base_active_secondary_fg, bg = base_bg },
                c = { fg = base_active_secondary_fg, bg = base_bg },
            },
            replace = {
                a = { fg = base_active_primary_fg, bg = horizon.dark_blue, gui = "bold" },
                b = { fg = base_active_secondary_fg, bg = base_bg },
                c = { fg = base_active_secondary_fg, bg = base_bg },
            },
            normal = {
                a = { fg = base_active_primary_fg, bg = horizon.orange, gui = "bold" },
                b = { fg = base_active_secondary_fg, bg = base_bg },
                c = { fg = base_active_secondary_fg, bg = base_bg },
            },
            insert = {
                a = { fg = base_active_primary_fg, bg = horizon.dark_blue, gui = "bold" },
                b = { fg = base_active_secondary_fg, bg = base_bg },
                c = { fg = base_active_secondary_fg, bg = base_bg },
            },
            command = {
                a = { fg = base_active_primary_fg, bg = horizon.green, gui = "bold" },
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
            lualine_b = {},
            lualine_c = {},
            lualine_x = { buffer_opts },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
    }
end

return {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    config = config,
}
