local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
if not null_ls_status_ok then
    vim.notify('could not find null-ls - skipping config')
    return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
    debug = false,
    sources = {
        formatting.black.with( { extra_args = {"--fast"} }),
        diagnostics.mypy,
    }
})
