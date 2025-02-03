local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

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

local function lines_to_table(lines)
  return lines:gmatch("[^\r\n]+")
end

local function get_iconline_for_space(space, callback)
  local space_name = space.as_name
  sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(windows)
    local icon_line = ""
    for app in lines_to_table(windows) do
      local lookup = app_icons[app]
      local icon = ((lookup == nil) and app_icons["Default"] or lookup)
      icon_line = icon_line .. " " .. icon
    end

    callback(icon_line)
  end)
end


local function query_focused_workspace(callback)
  sbar.exec("aerospace list-workspaces --format %{workspace} --focused", function(focused_workspace)
    focused_workspace = trim(focused_workspace)
    callback(focused_workspace)
  end)
end


local function set_space_focus(space, is_focused)
  local label = space:query().label.value
  local is_empty = label == " —"
  local draw_space = is_focused or not is_empty or (space.as_name == "1")

  if space:query().drawing == draw_space then
    return
  end

  space:set({
    icon = { highlight = is_focused },
    label = { highlight = is_focused },
  })
  space.bracket:set({
    background = { border_color = is_focused and colors.named_base.strings or colors.named_base.bg_lighter },
  })
end

local function refresh_space_windows(space, is_focused)
  get_iconline_for_space(space, function(icon_line)
    if icon_line == "" then
      icon_line = " —"
    end

    sbar.animate("tanh", 20, function()
      space:set({ label = icon_line })
      set_space_focus(space, is_focused)
    end)
  end)
end

local function set_space_display(space, display_id)
  space:set({ display = display_id })
  space.bracket:set({ display = display_id })
  space.padding:set({ display = display_id })
end

local function init_space(space_name, display_id, is_focused)
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
  space.as_name = space_name

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

  set_space_display(space, display_id)
  refresh_space_windows(space, is_focused)

  space:subscribe({ "space_windows_change" }, function(env)
    query_focused_workspace(function(focused)
      if space.as_name == focused then
        refresh_space_windows(space, true)
      end
    end)
  end)

  space:subscribe({ "aerospace_workspace_change" }, function(env)
    is_focused = env.FOCUSED_WORKSPACE == space_name
    local env_prev_focused = env.PREV_WORKSPACE == space_name

    if (is_focused or env_prev_focused) then
      refresh_space_windows(space, is_focused)
    end
  end)

  space:subscribe({ "aerospace_display_change" }, function(env)
    sbar.exec(
      "aerospace list-workspaces --all --format %{workspace}';'%{monitor-appkit-nsscreen-screens-id}",
      function(space_monitor_ids)
        for space_monitor_id in lines_to_table(space_monitor_ids) do
          parts = split(space_monitor_id, ";")
          if parts[1] == space_name then
            set_space_display(space, parts[2])
          end
        end
      end)
  end)

  space:subscribe("mouse.clicked", function()
    sbar.exec("aerospace workspace " .. space_name)
  end)

  return space
end

query_focused_workspace(function(focused)
  sbar.exec("aerospace list-workspaces --all --format %{workspace}';'%{monitor-appkit-nsscreen-screens-id}",
    function(space_monitor_ids)
      for space_monitor_id in lines_to_table(space_monitor_ids) do
        local parts = split(space_monitor_id, ";")
        local space_name = parts[1]
        local display_id = parts[2]
        local is_focused = space_name == focused

        init_space(space_name, display_id, is_focused)
      end
    end
  )
end)
