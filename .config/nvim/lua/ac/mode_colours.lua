-- change cursor colours on mode switch

local horizon = require('ac.horizon_colours')

local mode_colours = {
    normal = horizon.orange,
    insert = horizon.dark_blue,
    terminal = horizon.green,
    replace = horizon.dark_blue,
    visual = horizon.pink,
    visual_selected = horizon.dull_pink,
    command = horizon.green,
}

return mode_colours
