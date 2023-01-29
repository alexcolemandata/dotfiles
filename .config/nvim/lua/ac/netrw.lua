local g = vim.g

g.netrw_keepdir = 0
g.netrw_banner = 0
g.netrw_winsize = 30
g.netrw_liststyle = 0
g.netrw_list_hide = { '\\.DS_Store', '\\./', '\\.\\./' }
vim.cmd[[let g:netrw_list_hide= '.*\.swp$,.DS_Store,*/tmp/*,*.so,*.swp,*.zip,*.git,^\.\.\=/\=$']]
g.netrw_browse_split = 0
