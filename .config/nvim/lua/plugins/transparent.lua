return {
	"xiyaowong/nvim-transparent",
	lazy = false,
	priority = 999,
	config = function()
		vim.cmd("TransparentEnable")
	end
}
