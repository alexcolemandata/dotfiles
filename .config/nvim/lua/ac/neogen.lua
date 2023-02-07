local status_ok, neogen = pcall(require, "neogen")
if not status_ok then
    vim.notify("neogen not detected - skipping config")
    return
end

local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)

neogen.setup {
    enabled = true,
    languages = {
        python = {
            template = {
                annotation_convention = "numpydoc"
                }
        },
    }
}
