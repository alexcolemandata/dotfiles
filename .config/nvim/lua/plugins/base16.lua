local base16_theme = "da-one-sea"

return {
	"RRethy/nvim-base16",
	lazy = false,
	priority = 999, -- high prio
	config = function()
		vim.cmd("colorscheme base16-" .. base16_theme)
	end,
}
