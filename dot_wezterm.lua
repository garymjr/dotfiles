local wezterm = require("wezterm")
local colors = require("lua/kanagawa").colors()

local function get_process_name(tab)
    local process_name = tab.active_pane.foreground_process_name
    return string.format("%s", string.gsub(process_name, "(.*[/\\])(.*)", "%2"))
end

-- local function get_current_working_dir(tab)
--     local current_dir = tab.active_pane.current_working_dir
--     local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

--     return current_dir == HOME_DIR and "~"
--         or string.format("%s", string.gsub(current_dir, "(.*[/\\])(.*)", "%2"))
-- end

wezterm.on("update-right-status", function(window)
    local ampm = string.lower(wezterm.strftime("%p"))
    local date = wezterm.strftime("%-I:%M")
    window:set_right_status(wezterm.format({
        { Foreground = { Color = "#1f1f28" } },
        { Background = { Color = "#76946a" } },
        { Text = " " },
        { Text = date },
        { Text = ampm },
        { Text = " " },
    }))
end)

wezterm.on("format-tab-title", function(tab)
    if tab.is_active then
        return wezterm.format({
            { Text = " " },
            { Text = string.format("%d: ", tab.tab_index + 1) },
            { Text = get_process_name(tab) },
            { Text = " " },
        })
    end

    return wezterm.format({
        { Text = " " },
        { Text = string.format("%d: ", tab.tab_index + 1) },
        { Text = get_process_name(tab) },
        { Text = " " },
    })
end)

return {
    enable_tab_bar = true,
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    show_new_tab_button_in_tab_bar = false,
    tab_max_width = 50,
    force_reverse_video_cursor = true,
    -- font = wezterm.font({ family = "JetBrainsMono Nerd Font", weight = "Regular" }),
    font = wezterm.font({ family = "Operator Mono Lig", weight = "Book" }),
    -- font = wezterm.font({ family = "League Mono", weight = "Regular" }),
    font_size = 15.5,
    max_fps = 120,
    window_padding = {
        top = 0,
        right = 0,
        bottom = 0,
        left = 0
    },
    colors = colors,
    -- window_frame = window_frame,
    line_height = 1.10,
    disable_default_key_bindings = true,
    leader = { key = " ", mods = "CTRL" },
    keys = {
        { key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
        { key = "\\", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
        { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
        { key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
        { key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
        { key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
        { key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
        { key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
        { key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = {"Left", 5} }) },
        { key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = {"Down", 5} }) },
        { key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = {"Up", 5} }) },
        { key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = {"Right", 5} }) },
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
        { key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
        { key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
        { key = "o", mods = "LEADER", action = wezterm.action.SpawnCommandInNewTab({ args = {"/opt/homebrew/bin/lf"} }) },
        { key = "g", mods = "LEADER", action = wezterm.action.SpawnCommandInNewTab({ args = {"/usr/local/bin/gitui"} }) },
        { key = "/", mods = "LEADER", action = wezterm.action.Search({ CaseInSensitiveString = '' }) },
        { key = "c", mods = "SUPER", action = wezterm.action({ CopyTo = "Clipboard" }) },
        { key = "v", mods = "SUPER", action = wezterm.action({ PasteFrom = "Clipboard" }) },
        { key = "-", mods = "SUPER", action = "DecreaseFontSize" },
        { key = "=", mods = "SUPER", action = "IncreaseFontSize" },
        { key = "q", mods = "SUPER", action = wezterm.action.QuitApplication },
    },
}
