return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python"
  },
  config = function()
    local neotest = require("neotest")
    ---@diagnostic disable-next-line: missing-fields
    neotest.setup({
      adapters = {
        require("neotest-python")({
          runner = "pytest",
          args = { "-vv", "--log-level", "DEBUG" },
          -- Extra arguments for nvim-dap configuration
          -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
          -- dap = { justMyCode = true },
          -- Command line arguments for runner
          -- Can also be a function to return dynamic values
          -- Runner to use. Will use pytest if available by default.
          -- Can be a function to return dynamic value.
          -- Custom python path for the runner.
          -- Can be a string or a list of strings.
          -- Can also be a function to return dynamic value.
          -- If not provided, the path will be inferred by checking for
          -- virtual envs in the local directory and for Pipenev/Poetry configs
          -- python = ".venv/bin/python",
          -- Returns if a given file path is a test file.
          -- NB: This function is called a lot so don't perform any heavy tasks within it.
          -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
          -- instances for files containing a parametrize mark (default: false)
          pytest_discover_instances = true,
        })
      }
    })

    -- test nearest
    vim.keymap.set("n", "<Leader>tt", function() neotest.run.run() end)

    -- test current file
    vim.keymap.set("n", "<Leader>tf", function() neotest.run.run(vim.fn.expand("%:h")) end)

    vim.keymap.set("n", "<Leader>tl", function() neotest.run.run_last() end)
    vim.keymap.set("n", "<Leader>to", function() neotest.output.open({ enter = true }) end)
    vim.keymap.set("n", "<Leader>tO", function() neotest.output_panel.toggle() end)

    vim.keymap.set("n", "t<CR>", neotest.run.run)
    vim.keymap.set("n", "[t", function() neotest.jump.prev({ status = "failed" }) end)
    vim.keymap.set("n", "]t", function() neotest.jump.next({ status = "failed" }) end)
  end
}
