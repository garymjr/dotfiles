local wezterm = require("wezterm")

local function get_process_name(tab)
  local process_name = tab.active_pane.foreground_process_name
  return string.format("%s", string.gsub(process_name, "(.*[/\\])(.*)", "%2"))
end

wezterm.on("update-status", function(window)
  window:set_left_status(wezterm.format({
    { Attribute = { Intensity = "Bold" } },
    { Background = { Color = "#c34043" } },
    { Foreground = { Color = "#1f1f28" } },
    { Text = " " },
    { Text = window:active_workspace() },
    { Text = " " },
    "ResetAttributes",
  }))
end)

wezterm.on("format-tab-title", function(tab)
  local format = {
    { Text = " " },
    { Text = string.format("%d: ", tab.tab_index + 1) },
  }

  if tab.is_active then
    table.insert(format, 1, { Background = { Color = "#1f1f28" } })
  else
    table.insert(format, 1, { Background = { Color = "#0c0c0f" } })
  end

  if tab.tab_title ~= "" then
    table.insert(format, { Text = tab.tab_title })
  else
    table.insert(format, { Text = get_process_name(tab) })
  end

  table.insert(format, { Text = " " })

  return wezterm.format(format)
end)

local function is_vim(pane)
  return pane:get_foreground_process_name():find("n?vim") ~= nil
end

local direction_keys = {
  Left = "h",
  Down = "j",
  Up = "k",
  Right = "l",
  -- reverse lookup
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

local config = wezterm.config_builder()

config.color_scheme = "Kanagawa (Gogh)"

config.colors = {
  tab_bar = {
    background = "#1e1e2e",
  },
}

-- config.debug_key_events = true
-- config.disable_default_key_bindings = true
config.enable_tab_bar = true
config.font = wezterm.font({ family = "MonaspiceNe Nerd Font" })

config.font_rules = {
  {
    italic = true,
    font = wezterm.font({ family = "MonaspiceRn Nerd Font" }),
  },
}

config.harfbuzz_features = { "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08", "calt", "dlig" }
config.font_size = 14
config.force_reverse_video_cursor = true
config.leader = { key = "Space", mods = "CTRL" }

config.keys = {
  { key = "Space", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\0" }) },
  { key = "-",     mods = "LEADER",      action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
  {
    key = "\\",
    mods = "LEADER",
    action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
  },
  { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
  { key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
  -- { key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
  -- { key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
  -- { key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
  -- { key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
  -- { key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
  -- { key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
  -- { key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
  -- { key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
  -- { key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
  { key = "p", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = -1 }) },
  { key = "n", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = 1 }) },
  { key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
  { key = "w", mods = "SUPER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
  { key = "[", mods = "LEADER", action = wezterm.action.Search({ CaseInSensitiveString = "" }) },
  -- { key = "-", mods = "SUPER",  action = "DecreaseFontSize" },
  -- { key = "=", mods = "SUPER",  action = "IncreaseFontSize" },
  -- { key = "c", mods = "SUPER", action = wezterm.action({ CopyTo = "Clipboard" }) },
  { key = "x", mods = "SUPER|SHIFT", action = wezterm.action.ActivateCopyMode },
  -- { key = "v", mods = "SUPER", action = wezterm.action({ PasteFrom = "Clipboard" }) },
  { key = "q", mods = "SUPER",  action = wezterm.action.QuitApplication },
  { key = "?", mods = "LEADER",  action = wezterm.action.ShowLauncher },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      local workspaces = {}
      for i, workspace in ipairs(wezterm.mux.get_workspace_names()) do
        table.insert(workspaces, { id = string.format("%d", i), label = workspace })
      end

      window:perform_action(
        wezterm.action.InputSelector({
          action = wezterm.action_callback(function(w, p, _, label)
            if not label then
              return
            end

            w:perform_action(
              wezterm.action.SwitchToWorkspace({
                name = label,
              }),
              p
            )
          end),
          choices = workspaces,
          title = "Select workspace",
          fuzzy = true,
        }),
        pane
      )
    end),
  },
  -- {
  --   key = "w",
  --   mods = "LEADER",
  --   action = wezterm.action.PromptInputLine({
  --     description = "New workspace",
  --     action = wezterm.action_callback(function(window, pane, line)
  --       if not line then
  --         return
  --       end
  --
  --       window:perform_action(
  --         wezterm.action.SwitchToWorkspace({
  --           name = line,
  --         }),
  --         pane
  --       )
  --     end),
  --   }),
  -- },
  {
    key = "n",
    mods = "SUPER|SHIFT",
    action = wezterm.action.PromptInputLine({
      description = "New workspace",
      action = wezterm.action_callback(function(window, pane, line)
        if not line then
          return
        end

        window:perform_action(
          wezterm.action.SwitchToWorkspace({
            name = line,
          }),
          pane
        )
      end),
    }),
  },
  {
    key = "v",
    mods = "CTRL",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = "c",
    mods = "CTRL",
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = "Enter",
    mods = "ALT",
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- move between split panes
  split_nav("move", "h"),
  split_nav("move", "j"),
  split_nav("move", "k"),
  split_nav("move", "l"),
  -- resize panes
  split_nav("resize", "h"),
  split_nav("resize", "j"),
  split_nav("resize", "k"),
  split_nav("resize", "l"),
  {
    key = ",",
    mods = "LEADER",
    action = wezterm.action.PromptInputLine({
      description = "Rename tab",
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
}

config.max_fps = 120
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 50
config.term = "wezterm"
config.use_fancy_tab_bar = false

config.window_padding = {
  top = 0,
  right = 0,
  bottom = 0,
  left = 0,
}

return config
