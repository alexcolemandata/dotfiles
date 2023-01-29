local g = vim.g

local transparency = 0.94

if not g.neovide then
    return
end

-- neovide (GUI client) config
vim.notify("detected running inside neovide - configuring neovide specific options")
vim.notify("transparency:"..transparency)
vim.opt.guifont = { "SauceCodePro Nerd Font", ":h16"}
g.neovide_transparency = transparency
g.transparency = transparency
g.neovide_refresh_rate = 60
g.neovide_refresh_rate_idle = 30
g.neovide_no_idle = true
g.neovide_input_use_logo = true
g.neovide_input_macos_alt_is_meta = true
g.neovide_hide_cursor_while_typing = true

-- silly stuff
-- "ripple", "pixiedust", "railgun", "
g.neovide_cursor_animation_length = 0.04
g.neovide_cursor_trail_size = 0.5
g.neovide_cursor_vfx_mode = "pixiedust"
g.neovide_cursor_vfx_particle_lifetime = 0.4
g.neovide_cursor_vfx_particle_density = 500
g.neovide_cursor_vfx_particle_speed = 18
g.neovide_cursor_vfx_opacity = 80

-- changing scale with command +-
local size_up_factor = 0.1
local size_cmd = ':let g:neovide_scale_factor=(g:neovide_scale_factor'

local size_up_cmd = size_cmd..' + '..size_up_factor..')<CR>'
local size_down_cmd = size_cmd..' - '..size_up_factor..')<CR>'

vim.api.nvim_set_keymap('n', '<D-=>', size_up_cmd, { noremap = true })
vim.api.nvim_set_keymap('n', '<D-->', size_down_cmd, { noremap = true })
vim.api.nvim_set_keymap('i', '<D-=>', '<ESC>'..size_up_cmd..'a', { noremap = true })
vim.api.nvim_set_keymap('i', '<D-->', '<ESC>'..size_down_cmd..'a', { noremap = true })
vim.api.nvim_set_keymap('v', '<D-=>', '<ESC>'..size_up_cmd..'gv', { noremap = true })
vim.api.nvim_set_keymap('v', '<D-->', '<ESC>'..size_down_cmd..'gv', { noremap = true })
