---@meta

---@class TabInformation
---@field is_active boolean is true if this tab is the active tab
---@field tab_id integer the identifier for the tab
---@field tab_index integer the logical tab position within its containing window, with 0 indicating the leftmost tab
---@field window_id integer the ID of the window that contains this tab (Since: Version 20220807-113146-c2fee766)
---@field window_title string the title of the window that contains this tab (Since: Version 20220807-113146-c2fee766)
---@field tab_title string the title of the tab (Since: Version 20220807-113146-c2fee766)

-- TODO: add this once PaneInformation has been added
--
-- active_pane - the PaneInformation for the active pane in this tab
