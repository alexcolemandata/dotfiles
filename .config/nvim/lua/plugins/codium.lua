return {
    "Exafunction/codeium.vim",
    lazy = true,
    event = "BufEnter",
    config = function()
        vim.keymap.set("i", "<C-j>",
            function()
                return vim.fn['codeium#Accept']()
            end,
            { expr = true })
    end
}
