return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
        "MunifTanjim/nui.nvim",
        {
            "rcarriga/nvim-notify",
            config = function()
                require("notify").setup({
                    background_colour = "#000000",
                    fps = 60,
                    render = "compact",
                    stages = "fade",
                    timeout = 3500,
                    top_down = true,
                })
            end,
        },
    },
}
