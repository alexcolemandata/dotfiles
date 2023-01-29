vim.notify("applying custom lualine theme")
local horizon = require("ac.horizon_colours")
local mode = require("ac.mode_colours")

local base_bg = horizon.dark_grey
local base_inactive_fg = horizon.grey
local base_active_primary_fg = horizon.darker_grey
local base_active_secondary_fg = horizon.lightest_grey

local M = {}
M.theme = function()
    return {
        inactive = {
            a = { fg = base_inactive_fg, bg = nil },
            b = { fg = base_inactive_fg, bg = nil },
            c = { fg = base_inactive_fg, bg = base_bg },
        },
        terminal = {
            a = { fg = base_active_primary_fg, bg = mode.terminal, gui="bold" },
            b = { fg = base_active_secondary_fg, bg = base_bg },
            c = { fg = base_active_secondary_fg, bg = base_bg },
        },
        visual = {
            a = { fg = base_active_primary_fg, bg = mode.visual, gui = "bold" },
            b = { fg = base_active_secondary_fg, bg = base_bg },
            c = { fg = base_active_secondary_fg, bg = base_bg },
        },
        replace = {
            a = { fg = base_active_primary_fg, bg = mode.replace, gui = "bold" },
            b = { fg = base_active_secondary_fg, bg = base_bg },
            c = { fg = base_active_secondary_fg, bg = base_bg },
        },
        normal = {
            a = { fg = base_active_primary_fg, bg = mode.normal, gui = "bold" },
            b = { fg = base_active_secondary_fg, bg = base_bg },
            c = { fg = base_active_secondary_fg, bg = base_bg },
        },
        insert = {
            a = { fg = base_active_primary_fg, bg = mode.insert, gui = "bold" },
            b = { fg = base_active_secondary_fg, bg = base_bg },
            c = { fg = base_active_secondary_fg, bg = base_bg },
        },
        command = {
            a = { fg = base_active_primary_fg, bg = mode.command, gui = "bold" },
            b = { fg = base_active_secondary_fg, bg = base_bg },
            c = { fg = base_active_secondary_fg, bg = base_bg },
        },
    }

end
return M
