local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    vim.notify("lualine not detected - skipping config")
    return
else
    vim.notify("configuring lualine")
end

local branch_formatting = {}

local has_horizon_colours, horizon_colours = pcall(require, "ac.horizon_colours")
if not has_horizon_colours then
    vim.notify("could not find horizon colours - using default for lualine formatting")
    branch_formatting = { gui="italic", fg='#29d398' }
else
    branch_formatting = { gui="italic", fg=horizon_colours.green }
end

local get_theme = function()
    local found_theme, custom = pcall(require, "ac.lualine_theme")
    if not found_theme then
        vim.notify("could not find custom lualine theme - using horizon")
        return 'horizon'
    else
        return custom.theme()
    end
end

local buffer_opts = {
                "buffers",
                icons_enabled = false,
                max_length = vim.o.columns * 4 / 5,
                mode=0,
                buffers_color = {
                  --active = 'lualine_a_insert',
                  active={fg=horizon_colours.blue, gui='bold'}
                },
                symbols = {
                  modified = ' ●',      -- Text to show when the buffer is modified
                  alternate_file = '', -- Text to show to identify the alternate file
                  directory = '',     -- Text to show when the buffer is a directory
                },
                section_separators = { left = '', right = ''},
                component_separators = { left = '', right = ''},
            }

local function dir_path()
    local home = tostring(os.getenv("HOME"))
    for dir in vim.fs.parents(vim.api.nvim_buf_get_name(0)) do
        local path, _ = tostring(dir):gsub(home, "~", 1)
        return path
    end
end

local function shell_result_from_buffer_dir(cmd)
    local subshell_cmd = "(cd ".. dir_path().. " && ".. cmd.. " 2>/dev/null | tr -d '\n')"
    return vim.fn.system(subshell_cmd)
end

local function is_inside_repo()
    return shell_result_from_buffer_dir("git rev-parse --is-inside-work-tree") == "true"
end

local function repo_name()
    return shell_result_from_buffer_dir("basename `git rev-parse --show-toplevel`")
end

local function repo_or_dir()
    if is_inside_repo() then
        return ' '..repo_name()
    else
        return ' '..dir_path()
    end
end

vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre"}, {
	callback = function()
        vim.api.nvim_buf_set_var(0, "repo_or_dir", repo_or_dir())
    end
})

local function component_repo_or_dir()
    return vim.api.nvim_buf_get_var(0, "repo_or_dir")
end


local function not_netrw()
    return vim.bo.filetype ~= 'netrw'
end

local filename_opts_active = {
                "filename",
                path = 0,
                color = {fg = horizon_colours.blue, gui="bold"},
                cond=not_netrw
            }

local filename_opts_inactive = {
                "filename",
                path = 0,
                color = {fg = horizon_colours.lighter_grey, gui="bold"},
                cond=not_netrw
            }

lualine.setup {
  options = {
    icons_enabled = true,
    theme = get_theme(),
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = false,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    -- LHS
    lualine_a = {'mode'},
    lualine_b = { },
    lualine_c = { },
    -- RHS
    lualine_x = { buffer_opts },
    lualine_y = { },
    lualine_z = { }
  },
  inactive_sections = { }, -- not used currently with globalstatus=true
  tabline = { },
  winbar = {
        lualine_a = { },
        lualine_b = { },
        lualine_c = {
            {component_repo_or_dir, color={fg=horizon_colours.dark_blue}, cond=not_netrw},
            filename_opts_active,
        },
        lualine_x = { },
        lualine_y = { 'diff', {'branch', color = branch_formatting}},
        lualine_z = { }
  },
  inactive_winbar = {
        lualine_a = { },
        lualine_b = { },
        lualine_c = {
            {component_repo_or_dir, color={fg=horizon_colours.lightish_grey}, cond=not_netrw},
            filename_opts_inactive,
        },
        lualine_x = { },
        lualine_y = { },
        lualine_z = { }
  },
  extensions = {}
}

