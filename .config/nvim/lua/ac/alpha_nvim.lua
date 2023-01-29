local alpha_ok, alpha = pcall(require, 'alpha')

if not alpha_ok then
    vim.notify("could not find alpha-vim, skipping configuration")
    return
end

alpha.setup(require('alpha.themes.dashboard').config)
