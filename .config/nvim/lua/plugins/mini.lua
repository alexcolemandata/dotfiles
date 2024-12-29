return {
    {
        'echasnovski/mini.nvim',
        lazy = false,
        config = function()
            local statusline = require 'mini.statusline'
            statusline.setup { use_icons = true }
        end
    }
}
