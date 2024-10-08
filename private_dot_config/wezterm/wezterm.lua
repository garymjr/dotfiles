---@diagnostic disable: assign-type-mismatch
--- @type wezterm
local wezterm = require("wezterm")

--- @param tab TabInformation
local function get_process_name(tab)
	local process_name = tab.active_pane.foreground_process_name
	return string.format("%s", string.gsub(process_name, "(.*[/\\])(.*)", "%2"))
end

wezterm.on("update-right-status", function(window)
	local time = os.date("%H:%M %p")
	window:set_right_status(wezterm.format({
		{ Background = { Color = "#a6da95" } },
		{ Foreground = { Color = "#1e2030" } },
		{ Text = "  " },
		{ Background = { Color = "#363a4f" } },
		{ Foreground = { Color = "#a6adc8" } },
		{ Text = " " },
		{ Text = window:active_workspace() },
		{ Text = " " },
		{ Background = { Color = "#8aadf4" } },
		{ Foreground = { Color = "#1e2030" } },
		{ Text = " 󰃰 " },
		{ Background = { Color = "#363a4f" } },
		{ Foreground = { Color = "#a6adc8" } },
		{ Text = " " },
		{ Text = time },
		{ Text = " " },
		"ResetAttributes",
	}))
end)

wezterm.on("format-tab-title", function(tab)
	local format = {
    { Foreground = { Color = "#1e2030" } },
  }

	if tab.is_active then
		table.insert(format, { Background = { Color = "#f5a97f" } })
  else
		table.insert(format, { Background = { Color = "#8aadf4" } })
	end

  -- tab index
	table.insert(format, { Text = " " })
	table.insert(format, { Text = string.format("%d", tab.tab_index + 1) })
	table.insert(format, { Text = " " })

  -- tab title
  table.insert(format, { Background = { Color = "#363a4f" } })
  table.insert(format, { Foreground = { Color = "#bac2de" } })
	table.insert(format, { Text = " " })

	if tab.tab_title ~= "" then
		table.insert(format, { Text = tab.tab_title })
	else
		table.insert(format, { Text = get_process_name(tab) })
	end

	table.insert(format, { Text = " " })
	table.insert(format, "ResetAttributes")

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

config.audible_bell = "Disabled"

config.color_scheme = "Catppuccin Macchiato"

---@diagnostic disable-next-line: missing-fields
config.colors = {
	---@diagnostic disable-next-line: missing-fields
	tab_bar = {
		background = "#1e2030",
	},
}

config.default_workspace = "scratch"

-- config.debug_key_events = true
-- config.disable_default_key_bindings = true
config.enable_tab_bar = true
config.font = wezterm.font({ family = "CommitMono" })

-- config.font_rules = {
-- 	{
-- 		italic = true,
-- 		font = wezterm.font({ family = "Comm", style = "Italic" }),
-- 	},
-- }

-- NOTE: this is for monaspace fonts
--
-- config.harfbuzz_features = { "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08", "calt", "dlig" }
config.font_size = 18
config.force_reverse_video_cursor = true
config.front_end = "WebGpu"
config.leader = { key = "Space", mods = "CTRL" }
config.line_height = 1.3

config.keys = {
	{ key = "Space", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\0" }) },
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
	},
	{
		key = "\\",
		mods = "LEADER",
		action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
	},
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "p", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = -1 }) },
	{ key = "n", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = 1 }) },
	{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	{ key = "w", mods = "SUPER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	{ key = "[", mods = "LEADER", action = wezterm.action.Search({ CaseInSensitiveString = "" }) },
	{ key = "x", mods = "SUPER|SHIFT", action = wezterm.action.ActivateCopyMode },
	{ key = "q", mods = "SUPER", action = wezterm.action.QuitApplication },
	{ key = "p", mods = "SUPER", action = wezterm.action.ShowLauncher },
	{ key = "s", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{ key = "t", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|TABS" }) },
	{ key = "?", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|COMMANDS" }) },
	{
		key = "w",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Create workspace",
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
	{
		key = "g",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ args = { "lazygit" } }),
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

config.max_fps = 255
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
