local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local item_order = ""

-- Global table to map aerospace_id to display_id
local aerospace_to_display_map = {}

-- Constants for main and secondary aerospace IDs
local main_aerospace_id = nil
local secondary_aerospace_id = nil

-- Function to get the main aerospace ID
local function get_main_aerospace_id(callback)
  sbar.exec("aerospace list-monitors --format %{monitor-id}", function(monitors)
    for aerospace_monitor_id in monitors:gmatch("[^\r\n]+") do
      sbar.exec(
        "aerospace list-workspaces --format %{workspace} --monitor " .. aerospace_monitor_id,
        function(workspaces)
          -- Check if workspace '1' is in the list
          if workspaces:match("%f[%d]1%f[%D]") then
            callback(aerospace_monitor_id)
          end
        end
      )
    end
  end)
end

-- Function to get the secondary aerospace ID
local function get_secondary_aerospace_id(callback)
  sbar.exec("aerospace list-monitors --format %{monitor-id}", function(monitors)
    for aerospace_monitor_id in monitors:gmatch("[^\r\n]+") do
      sbar.exec(
        "aerospace list-workspaces --format %{workspace} --monitor " .. aerospace_monitor_id,
        function(workspaces)
          -- Check if workspace '2' is in the list
          if workspaces:match("%f[%d]2%f[%D]") then
            callback(aerospace_monitor_id)
          end
        end
      )
    end
  end)
end

local function get_num_displays(callback)
  sbar.exec("aerospace list-monitors --count", function(monitor_count)
    -- Trim whitespace from the result
    local trimmed_count = monitor_count:match("^%s*(.-)%s*$") -- Removes leading and trailing whitespace
    -- Use the callback to pass back the trimmed result
    callback(trimmed_count)
  end)
end

-- Function to initialize the display mapping
local function init_display_mapping()
  -- Get the number of displays
  get_num_displays(function(num_displays)
    num_displays = tonumber(num_displays) -- Convert string to number
    if num_displays == 1 then
      -- Only 1 display, trivial mapping
      main_aerospace_id = 1
      aerospace_to_display_map[main_aerospace_id] = 1
      print("Mapping initialized for 1 display:", aerospace_to_display_map)
      return
    end

    -- Get the main aerospace ID
    get_main_aerospace_id(function(main_id)
      main_aerospace_id = main_id
      aerospace_to_display_map[main_aerospace_id] = 1

      -- Get the secondary aerospace ID
      get_secondary_aerospace_id(function(secondary_id)
        secondary_aerospace_id = secondary_id
        aerospace_to_display_map[secondary_aerospace_id] = 2

        -- Handle additional displays (if num_displays > 2)
        if num_displays > 2 then
          sbar.exec("aerospace list-monitors --format %{monitor-id}", function(monitors)
            for aerospace_monitor_id in monitors:gmatch("[^\r\n]+") do
              if
                  aerospace_monitor_id ~= main_aerospace_id
                  and aerospace_monitor_id ~= secondary_aerospace_id
              then
                aerospace_to_display_map[aerospace_monitor_id] = 3
              end
            end

            -- Print the mapping for debugging
            print("Mapping initialized for multiple displays:")
            for aerospace_id, display_id in pairs(aerospace_to_display_map) do
              print("Aerospace ID:", aerospace_id, "-> Display ID:", display_id)
            end
          end)
        else
          -- Print the mapping for debugging (if only 2 displays)
          print("Mapping initialized for 2 displays:")
          for aerospace_id, display_id in pairs(aerospace_to_display_map) do
            print("Aerospace ID:", aerospace_id, "-> Display ID:", display_id)
          end
        end
      end)
    end)
  end)
end

local function get_aerospace_id_from_display_id(display_id)
  for aerospace_id, mapped_display_id in pairs(aerospace_to_display_map) do
    if mapped_display_id == display_id then
      return aerospace_id
    end
  end
  return nil -- Return nil if no match is found
end

local function convert_aerospace_display_id(aerospace_display_id)
  -- if aerospace_display_id is in the mapping, return the mapping, otherwise 1
  if aerospace_to_display_map[aerospace_display_id] then
    return aerospace_to_display_map[aerospace_display_id]
  else
    return 1
  end
end

-- Call the initialization function
init_display_mapping()

local function handle_space_windows_change(space, space_name, is_selected)
  print("handle_space_windows_change space_name: " .. space_name)
  sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(windows)
    local no_app = true
    local icon_line = ""
    for app in windows:gmatch("[^\r\n]+") do
      no_app = false
      local lookup = app_icons[app]
      local icon = ((lookup == nil) and app_icons["Default"] or lookup)
      icon_line = icon_line .. " " .. icon
    end

    if no_app then
      icon_line = " —"
    end

    local draw_app = (not no_app) or is_selected
    print(
      space_name
      .. " draw_app="
      .. tostring(draw_app)
      .. " no_app="
      .. tostring(no_app)
      .. " is_selected="
      .. tostring(is_selected)
    )

    sbar.animate("tanh", 60, function()
      space:set({ label = icon_line, drawing = draw_app })
    end)
  end)
end

local function get_focused_workspace(env, callback)
  print("get_focused_workspace")
  local focused_workspace = env.FOCUSED_WORKSPACE

  -- check if env has focused workspace, a bit quicker than running command
  if focused_workspace and (focused_workspace ~= "") then
    print("env had focused workspace, focused_workspace: " .. focused_workspace)
    callback(focused_workspace)
  else
    print("env had no focused workspace, querying aerospace...")
    sbar.exec("aerospace list-workspaces --focused", function(focused)
      callback(focused:match("^%s*(.-)%s*$"))
    end)
  end
end

local function handle_aerospace_workspace_change(env, space, space_name, space_bracket)
  get_focused_workspace(env, function(focused)
    print("handle_aerospace_workspace_change space_name: " .. space_name .. " focused: " .. focused)
    local is_selected = (focused == space_name)
    local is_prev_selected = env.PREV_WORKSPACE == space_name

    -- TODO: might need this?
    -- if not (is_selected or is_prev_selected) then
    -- handle_space_windows_change(space, space_name, is_selected)
    -- return -- dont need to update
    -- end

    space:set({
      icon = { highlight = is_selected },
      label = { highlight = is_selected },
    })

    space_bracket:set({
      background = { border_color = is_selected and colors.named_base.strings or colors.named_base.bg_lighter },
    })

    handle_space_windows_change(space, space_name, is_selected)
  end)
end

local function handle_display_change(space, space_name)
  print("handle_display_change, space_name: " .. space_name)

  sbar.exec("aerospace list-monitors --format %{monitor-id}", function(monitors)
    for as_monitor_id in monitors:gmatch("[^\r\n]+") do
      sbar.exec(
        "aerospace list-workspaces --format %{workspace} --monitor " .. as_monitor_id,
        function(workspaces)
          -- Check if workspace is in the list
          if workspaces:match("%f[%d]" .. space_name .. "%f[%D]") then
            local display_id = convert_aerospace_display_id(as_monitor_id)
            space:set({ display = display_id })
          end
        end
      )
    end
  end)
end

sbar.exec("aerospace list-workspaces --all", function(spaces)
  for space_name in spaces:gmatch("[^\r\n]+") do
    local space = sbar.add("item", "space." .. space_name, {
      updates = true,
      icon = {
        font = { family = settings.font.numbers },
        string = space_name,
        padding_left = 7,
        padding_right = 3,
        color = colors.named_base.fg_default,
        highlight_color = colors.named_base.variables,
      },
      label = {
        padding_right = 12,
        color = colors.named_base.comments,
        highlight_color = colors.named_base.fg_default,
        font = "sketchybar-app-font:Regular:16.0",
        y_offset = -1,
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
      background = {
        color = colors.transparent,
        border_color = colors.named_base.fg_dark,
        height = 24,
        border_width = 1,
      },
    })

    -- Padding space
    local space_padding = sbar.add("item", "space.padding." .. space_name, {
      script = "",
      width = settings.group_paddings,
    })

    space:subscribe({ "aerospace_workspace_change", "space_windows_change" }, function(env)
      handle_aerospace_workspace_change(env, space, space_name, space_bracket)
    end)

    space:subscribe({ "aerospace_display_change", "display_change" }, function(env)
      handle_display_change(space, space_name)
    end)

    space:subscribe("mouse.clicked", function()
      sbar.exec("aerospace workspace " .. space_name)
    end)

    space:subscribe({ "forced", "power_source_change", "system_woke" }, function(env)
      handle_display_change(space, space_name)
      handle_aerospace_workspace_change(env, space, space_name, space_bracket)
    end)

    item_order = item_order .. " " .. space.name .. " " .. space_padding.name
  end
end)
