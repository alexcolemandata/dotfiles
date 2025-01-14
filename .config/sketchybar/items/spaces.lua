local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local item_order = ""

local function is_line_in_lines(lines, line)
  for lines_line in lines:gmatch("[^\r\n]+") do
    if line == lines_line then
      return true
    end
  end
  return false
end

local function split(input, delimiter)
  local result = {}
  for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
    table.insert(result, match)
  end
  return result
end

function trim(s)
  return (s:match("^%s*(.-)%s*$"))
end

local function get_iconline_for_space(space, callback)
  local space_name = space.as_name
  sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(windows)
    local icon_line = ""
    for app in windows:gmatch("[^\r\n]+") do
      local lookup = app_icons[app]
      local icon = ((lookup == nil) and app_icons["Default"] or lookup)
      icon_line = icon_line .. " " .. icon
    end

    callback(icon_line)
  end)
end

local function refresh_space_windows(space, is_focused)
  local space_name = space.as_name
  get_iconline_for_space(space, function(icon_line)
    local no_app = icon_line == ""
    local draw_app = (not no_app) or is_focused

    if icon_line == "" then
      icon_line = " —"
    end

    sbar.animate("tanh", 20, function()
      space:set({ label = icon_line, drawing = draw_app or (space_name == "1") })
    end)
  end)
end

local function query_focused_workspace(callback)
  sbar.exec("aerospace list-workspaces --format %{workspace} --focused", function(focused_workspace)
    focused_workspace = trim(focused_workspace)
    callback(focused_workspace)
  end)
end


function print_table(tbl, indent)
  indent = indent or 0
  local prefix = string.rep("  ", indent)

  for key, value in pairs(tbl) do
    if type(value) == "table" then
      print(prefix .. tostring(key) .. " = {")
      print_table(value, indent + 1)
      print(prefix .. "}")
    else
      print(prefix .. tostring(key) .. " = " .. tostring(value))
    end
  end
end

local function set_space_focus(space, is_focused)
  space:set({
    icon = { highlight = is_focused },
    label = { highlight = is_focused },
  })

  space.bracket:set({
    background = { border_color = is_focused and colors.named_base.strings or colors.named_base.bg_lighter },
  })
end

local function set_space_display(space, display_id)
  print("set_space_display(space.as_name=" .. space.as_name .. ", display_id='" .. display_id .. "')")
  space:set({ display = display_id })
  space.bracket:set({ display = display_id })
  space.padding:set({ display = display_id })
end

local function init_space(space_name, display_id, is_focused, is_empty)
  print("initializing space: " .. space_name .. " for display_id: " .. display_id)
  local draw_space = (space_name == "1") or not is_empty
  local space = sbar.add("item", "space." .. space_name, {
    updates = true,
    drawing = draw_space,
    icon = {
      font = { family = settings.font.numbers },
      string = space_name,
      padding_left = 7,
      padding_right = 3,
      color = colors.named_base.fg_default,
      highlight_color = colors.named_base.variables,
      highlight = false,
    },
    label = {
      padding_right = 12,
      color = colors.named_base.comments,
      highlight_color = colors.named_base.fg_default,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
      highlight = false,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.named_base.bg_default,
      border_width = 1,
      height = 22,
      border_color = colors.named_base.bg_lighter,
    },
  })
  space.as_name = space_name

  local space_bracket = sbar.add("bracket", { space.name }, {
    drawing = draw_space,
    background = {
      color = colors.transparent,
      border_color = colors.named_base.fg_dark,
      height = 24,
      border_width = 1,
    },
  })
  space.bracket = space_bracket

  local space_padding = sbar.add("item", "space.padding." .. space_name, {
    script = "",
    width = settings.group_paddings,
    drawing = draw_space,
  })
  space.padding = space_padding

  set_space_display(space, display_id)
  refresh_space_windows(space, is_focused)
  set_space_focus(space, is_focused)

  space:subscribe({ "space_windows_change" }, function(env)
    query_focused_workspace(function(focused)
      if space.as_name == focused then
        print("handle_space_windows_change: space.name" .. space.name)
        refresh_space_windows(space, true)
      end
    end)
  end)

  space:subscribe({ "aerospace_workspace_change" }, function(env)
    is_focused = env.FOCUSED_WORKSPACE == space_name
    local env_prev_focused = env.PREV_WORKSPACE == space_name

    if (is_focused or env_prev_focused) then
      print("aerospace_workspace_change, space.as_name=" .. space.as_name)
      set_space_focus(space, is_focused)
      refresh_space_windows(space, is_focused)
    end
  end)

  space:subscribe({ "aerospace_display_change" }, function(env)
    print("handle_display_change, space_name: " .. space_name)
    sbar.exec(
      "aerospace list-workspaces --all --format %{workspace}';'%{monitor-appkit-nsscreen-screens-id}",
      function(space_monitor_ids)
        for space_monitor_id in space_monitor_ids:gmatch("[^\r\n]+") do
          parts = split(space_monitor_id, ";")
          if parts[1] == space_name then
            set_space_display(space, parts[2])
          end
        end
        print("\n\n")
      end)
  end)

  space:subscribe("mouse.clicked", function()
    sbar.exec("aerospace workspace " .. space_name)
  end)

  return space
end


sbar.exec("aerospace list-monitors --format %{monitor-id}';'%{monitor-appkit-nsscreen-screens-id}",
  function(all_monitor_ids)
    query_focused_workspace(function(focused_space)
      for monitor_ids in all_monitor_ids:gmatch("[^\r\n]+") do
        local id_parts = split(trim(monitor_ids), ";")
        local as_monitor_id = id_parts[1]
        local sb_display_id = id_parts[2]

        sbar.exec("aerospace list-workspaces --monitor " .. as_monitor_id .. " --empty",
          function(empty_spaces)
            sbar.exec("aerospace list-workspaces --monitor " .. as_monitor_id, function(space_names)
              for space_name in space_names:gmatch("[^\r\n]+") do
                local is_focused = space_name == focused_space
                local is_empty = is_line_in_lines(empty_spaces, space_name)
                local space = init_space(space_name, sb_display_id, is_focused, is_empty)

                item_order = item_order .. " " .. space.name .. " " .. space.padding.name
              end
            end)
          end)
      end
    end
    )
  end
)
