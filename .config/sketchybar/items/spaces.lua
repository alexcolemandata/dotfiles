local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

EVENT_COUNTER = 0

local function print_table(tbl, indent)
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

  if indent == 0 then
    print("\n\n")
  end
end

function contains(list, element)
  for _, value in ipairs(list) do
    if value == element then
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

local function trim(s)
  return (s:match("^%s*(.-)%s*$"))
end


local function exec_and_log(cmd, callback)
  print(cmd)
  sbar.exec(cmd, function(result)
    callback(result)
  end)
end

local function get_focused_workspace(callback)
  exec_and_log("aerospace list-workspaces --focused", function(focused)
    callback(trim(focused))
  end)
end


local function get_windows(callback)
  exec_and_log(
    "aerospace list-windows --all --json --format %{workspace}%{app-name}%{monitor-appkit-nsscreen-screens-id}%{monitor-id}",
    callback
  )
end

local function get_monitors(callback)
  exec_and_log(
    "aerospace list-monitors --json --format %{monitor-id}%{monitor-appkit-nsscreen-screens-id}",
    callback
  )
end

local function get_workspaces(callback)
  exec_and_log(
    "aerospace list-workspaces --all --format %{workspace}%{monitor-appkit-nsscreen-screens-id} --json",
    callback
  )
end

local function get_visible_workspace_for_monitor(monitor_id, callback)
  exec_and_log(
    "aerospace list-workspaces --visible --monitor " .. tostring(monitor_id),
    callback
  )
end

local function get_visible_workspaces(monitors, callback)
  visible = {}
  local remaining = #monitors -- track pending async calls

  for _, monitor in ipairs(monitors) do
    get_visible_workspace_for_monitor(monitor["monitor-id"], function(vis)
      table.insert(visible, trim(vis))
      remaining = remaining - 1
      if remaining == 0 then
        callback(visible)
      end
    end)
  end
end

local function get_workspace_table(callback)
  local co = coroutine.create(function()
    local workspaces = coroutine.yield(get_workspaces)
    local windows = coroutine.yield(get_windows)
    local focused_space = coroutine.yield(get_focused_workspace)
    local monitors = coroutine.yield(get_monitors)
    local visible = coroutine.yield(get_visible_workspaces, monitors)

    local workspace_table = {
      focused = trim(focused_space),
      windows = windows,
      monitors = monitors,
      workspaces = workspaces,
      visible = visible
    }

    callback(workspace_table)
  end)

  local function resume_co(...)
    local success, next_fn, arg = coroutine.resume(co, ...)

    if not success then
      print("Coroutine error: ", next_fn)
      return
    end

    if coroutine.status(co) == "dead" then
      return
    end

    if arg ~= nil then
      next_fn(arg, function(result)
        resume_co(result)
      end)
    else
      next_fn(function(result)
        resume_co(result)
      end)
    end
  end

  resume_co()
end

local function set_space_focus(space, is_focused, is_visible, forced)
  is_focused = (is_focused == nil) and space.is_focused or is_focused
  is_visible = (is_visible == nil) and space.is_visible or is_visible
  if not forced and (space.is_focused == is_focused) and (space.visible == is_visible) then
    return
  end

  print("space_name: ", space.name, "is_focused: ", tostring(is_focused), "is_visible: ", tostring(is_visible),
    "forced: ", tostring(forced))
  print_table(space)
  space:set({
    icon = { highlight = is_focused },
    label = { highlight = is_focused },
  })
  space.bracket:set({
    background = { border_color = (is_focused or is_visible) and colors.named_base.strings or colors.named_base.bg_lighter },
  })

  space.is_focused = is_focused
  space.is_visible = is_visible
end

local function set_space_screen_id(space, screen_id)
  if space.screen_id == screen_id then
    return
  end

  space:set({ display = screen_id })
  space.bracket:set({ display = screen_id })
  space.padding:set({ display = screen_id })
  space.screen_id = screen_id
end

local function icon_line_from_windows(windows)
  local icon_line = ""
  for _, window in ipairs(windows) do
    local lookup = app_icons[window]
    local icon = ((lookup == nil) and app_icons["Default"] or lookup)
    icon_line = icon_line .. " " .. icon
  end

  if icon_line == "" then
    icon_line = " —"
  end

  return icon_line
end

local function set_space_windows(space, windows)
  local icon_line = icon_line_from_windows(windows)
  if space:query().label.value == icon_line then
    return
  end
  sbar.animate("tanh", 20, function()
    space:set({ label = icon_line })
  end)
end


local function init_space(space_name, space_data)
  print("init_space: " .. space_name)
  local is_focused = space_data["is_focused"]
  local windows = space_data["windows"]
  local is_visible = space_data["is_visible"]
  local screen_id = space_data["screen_id"]
  local space = sbar.add("item", "space." .. space_name, {
    updates = true,
    drawing = true,
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

  local space_bracket = sbar.add("bracket", { space.name }, {
    drawing = true,
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
    drawing = true,
  })
  space.padding = space_padding
  space.is_focused = is_focused
  space.is_visible = is_visible

  set_space_focus(space, is_focused, is_visible, true)
  set_space_screen_id(space, screen_id)
  set_space_windows(space, windows)

  space:subscribe("mouse.clicked", function()
    exec_and_log("aerospace workspace " .. space_name)
  end)

  return space
end

local function space_info_from_workspace_table(workspace_table)
  local focused = workspace_table["focused"]
  local visible = workspace_table["visible"]
  local workspaces = workspace_table["workspaces"]
  local space_info = {}

  for _, workspace_info in ipairs(workspaces) do
    local space_name = workspace_info["workspace"]
    space_info[space_name] = {}
    space_info[space_name]["is_focused"] = space_name == focused
    space_info[space_name]["is_visible"] = contains(visible, space_name)
    space_info[space_name]["screen_id"] = workspace_info["monitor-appkit-nsscreen-screens-id"]
    space_info[space_name]["windows"] = {}
  end

  for _, window_data in ipairs(workspace_table["windows"]) do
    local space_name = window_data["workspace"]
    local window_name = window_data["app-name"]
    table.insert(space_info[space_name]["windows"], window_name)
  end


  return space_info
end

local function refresh_spaces(counter, spaces, callback)
  if counter > EVENT_COUNTER + 1 then
    callback()
  else
    get_workspace_table(function(workspace_table)
      local space_info = space_info_from_workspace_table(workspace_table)
      for space_name, space in pairs(spaces) do
        local is_focused = space_info[space_name].is_focused
        local screen_id = space_info[space_name].screen_id
        local windows = space_info[space_name].windows
        local is_visible = space_info[space_name].is_visible

        set_space_focus(space, is_focused, is_visible)
        set_space_screen_id(space, screen_id)
        set_space_windows(space, windows)

        if EVENT_COUNTER >= 1000 then
          EVENT_COUNTER = 0
        else
          EVENT_COUNTER = EVENT_COUNTER + 1
        end
        callback(EVENT_COUNTER)
      end
    end)
  end
end

local function init_space_manager(workspace_table)
  local space_manager = sbar.add("item", "space_manager", {
    drawing = false,
    updates = true,
  })
  local event_counter = EVENT_COUNTER

  local space_info = space_info_from_workspace_table(workspace_table)
  local spaces = {}

  local space_names = {}
  for space_name in pairs(space_info) do
    table.insert(space_names, space_name)
  end
  table.sort(space_names)

  for _, space_name in ipairs(space_names) do
    local space_data = space_info[space_name]
    spaces[space_name] = init_space(space_name, space_data)
  end

  space_manager:subscribe({
    "routine", "forced", "system_woke", "space_windows_change" }, function(env)
    refresh_spaces(0, spaces, function() end)
  end)

  space_manager:subscribe({
    "aerospace_display_change" }, function()
    event_counter = event_counter + 1
    refresh_spaces(event_counter, spaces, function(updated)
      if updated then
        event_counter = updated
      end
    end
    )
  end)

  space_manager:subscribe({
    "aerospace_workspace_change",
  }, function(env)
    for space_name, space in pairs(spaces) do
      if space_name == env.PREV_WORKSPACE then
        set_space_focus(space, false)
      elseif space_name == env.FOCUSED_WORKSPACE then
        set_space_focus(space, true)
      end
    end

    event_counter = event_counter + 1
    refresh_spaces(event_counter, spaces, function(updated)
      if updated then
        event_counter = updated
      end
    end)
  end)
end

get_workspace_table(function(workspace_table)
  init_space_manager(workspace_table)
end)
