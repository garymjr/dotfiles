---@meta

--- A snapshot of some of the key characteristics of the tab,
--- intended for use in synchronous, fast, event callbacks that format
--- GUI elements such as the window and tab title bars
---@class TabInformation
---@field tab_id number The identifier for the tab
---@field tab_index number The logical tab position within its containing window, with 0 indicating the leftmost tab
---@field is_active boolean True if this tab is the active tab
---@field active_pane PaneInformation PaneInformation for the active pane in this tab
---@field window_id number The ID of the window that contains this tab
---@field window_title string The title of the window that contains this tab
---@field tab_title string The title of the tab

