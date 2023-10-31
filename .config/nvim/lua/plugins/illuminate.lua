-- highlights other instances of the word under the cursor
return {
    "RRethy/vim-illuminate",
    lazy = false,
    config = function()
        require('illuminate').configure({})
    end
}
