return {
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        config = {
            filters = { custom = { "^.git$" } }
        }
    },
    "nvim-tree/nvim-web-devicons"
}
