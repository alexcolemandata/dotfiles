return {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
    opts = {},
    main = "ibl",
    config = function()
        require("ibl").setup()
    end,
}
