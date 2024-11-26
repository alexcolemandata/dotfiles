return {
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		config = {
			sort = {
				sorter = "name",
				folders_first = true,
				files_first = false,
			},
			renderer = {
				indent_width = 2,
				special_files = {
					"pyproject.toml",
					"README.md",
				},
				highlight_opened_files = "all",
				highlight_modified = "icon",
				indent_markers = {
					enable = true,
				},
			},
			modified = {
				enable = true,
				show_on_dirs = true,
			},
			filters = {
				git_ignored = true,
				custom = { "^.git$" },
			},
		},
	},
	"nvim-tree/nvim-web-devicons",
}
