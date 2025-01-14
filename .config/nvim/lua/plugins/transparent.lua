return {
  "xiyaowong/nvim-transparent",
  lazy = false,
  enabled = false,
  priority = 999,
  config = function()
    vim.cmd("TransparentEnable")
  end
}
