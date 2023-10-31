return {
    "williamboman/mason.nvim",
    lazy = true,
    cmd = "Mason",
    event = "BufReadPre",
    config = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        },
    }
}
