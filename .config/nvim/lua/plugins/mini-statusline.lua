return {
  "echasnovski/mini.statusline",
  dependencies = {
    "echasnovski/mini-git",
    "echasnovski/mini.diff",
  },
  version = "*",
  config = function()
    require("mini.statusline").setup()
  end,
}
