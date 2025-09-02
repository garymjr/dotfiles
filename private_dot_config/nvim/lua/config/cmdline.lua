if vim.fn.executable "fd" == 1 then
  function _G.FdFindFiles(cmdarg, _cmdcomplete)
    local input = tostring(cmdarg or "")
    local input_starts_with_slash = vim.startswith(input, "/")
    -- Detect if the user provided a path hint (absolute, home, relative, or contains '/')
    local has_path_hint = input:find "/" ~= nil
      or vim.startswith(input, "~")
      or vim.startswith(input, ".")

    -- Non-recursive directory listing helper (skips .git)
    local function list_dir_non_recursive(path)
      local items = {}
      local fd = vim.uv.fs_scandir(path)
      if not fd then
        return items
      end
      while true do
        local name, _ = vim.uv.fs_scandir_next(fd)
        if not name then
          break
        end
        if name ~= ".git" then
          table.insert(items, vim.fs.normalize(vim.fs.joinpath(path, name)))
        end
      end
      return items
    end

    local base_dir = nil
    local needle = input
    local is_home_root = false

    if has_path_hint then
      -- Expand ~ and other modifiers
      local expanded = vim.fn.expand(input)
      local expanded_stat = vim.uv.fs_stat(expanded)

      if input:sub(-1) == "/" then
        base_dir = expanded
        needle = ""
      elseif expanded_stat and expanded_stat.type == "directory" then
        -- If the expanded path is an existing directory, search within it
        base_dir = expanded
        needle = ""
      else
        -- Otherwise split into parent and tail for fuzzy match within the parent
        base_dir = vim.fn.fnamemodify(expanded, ":h")
        needle = vim.fn.fnamemodify(expanded, ":t")
      end

      if base_dir == "" or base_dir == "." then
        base_dir = vim.fn.getcwd()
      end

      local real = vim.uv.fs_realpath(base_dir)
      if real then
        base_dir = real
      end

      -- If the path is exactly the user's home directory, avoid recursion; list only top-level entries
      local home = vim.uv.os_homedir() or vim.fn.expand "~"
      local base_norm = vim.fs.normalize(base_dir)
      local home_norm = vim.fs.normalize(vim.uv.fs_realpath(home) or home)
      local input_is_home_root = input == "~"
        or input == "~/"
        or expanded == home
        or expanded == (home .. "/")
      if base_norm == home_norm or input_is_home_root then
        is_home_root = true
      end
    end

    local fnames
    if base_dir then
      local stat = vim.uv.fs_stat(base_dir)
      if stat and stat.type == "directory" then
        -- Only avoid recursion at filesystem root or at the user's home directory
        local is_fs_root = base_dir == "/"
        if is_home_root or is_fs_root then
          fnames = list_dir_non_recursive(base_dir)
        else
          local fd_cmd = string.format(
            "fd --hidden --color=never --type f --exclude .git . %s",
            vim.fn.shellescape(base_dir)
          )
          fnames = vim.fn.systemlist(fd_cmd)
        end
      else
        fnames = {}
      end
    else
      fnames = vim.fn.systemlist "fd --hidden --color=never --type f --exclude .git"
    end

    -- Normalize to absolute paths when we had a base_dir and fd returned relative paths
    if base_dir and #fnames > 0 and not vim.startswith(fnames[1] or "", "/") then
      for i, f in ipairs(fnames) do
        fnames[i] = vim.fs.normalize(vim.fs.joinpath(base_dir, f))
      end
    end

    if #input == 0 then
      return fnames
    else
      local pattern = needle
      if pattern == nil or pattern == "" then
        -- No specific term after the path, return everything under the base_dir
        -- (or full list if no base_dir)
        -- When user typed '.../': show full list scoped to that directory
        -- Completion UI will handle narrowing as they type more
        -- Preserve tilde prefix when applicable below
        local results = fnames
        if vim.startswith(input, "~/") then
          local home = vim.uv.os_homedir() or vim.fn.expand "~"
          for i, m in ipairs(results) do
            if vim.startswith(m, home .. "/") then
              results[i] = "~/" .. m:sub(#home + 2)
            end
          end
        end
        return results
      end

      local matches = vim.fn.matchfuzzy(fnames, pattern)

      -- Preserve the user's tilde prefix if that is how they started typing
      if vim.startswith(input, "~/") then
        local home = vim.uv.os_homedir() or vim.fn.expand "~"
        for i, m in ipairs(matches) do
          if vim.startswith(m, home .. "/") then
            matches[i] = "~/" .. m:sub(#home + 2)
          end
        end
      end

      return matches
    end
  end

  vim.o.findfunc = "v:lua.FdFindFiles"
end

local function is_cmdline_type_find()
  local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]

  return cmdline_cmd == "find" or cmdline_cmd == "fin"
end

local function is_cmdline_type_buffer()
  local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]
  return cmdline_cmd == "b" or cmdline_cmd == "buffer"
end

-- Debounced wildmenu triggering to prevent popup flicker
local wild_timer = nil
local wildmode_set = false

local function should_enable_autocomplete()
  local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]
  return is_cmdline_type_find()
    or is_cmdline_type_buffer()
    or cmdline_cmd == "help"
    or cmdline_cmd == "h"
end

vim.api.nvim_create_autocmd({ "CmdlineChanged", "CmdlineLeave" }, {
  pattern = { "*" },
  group = vim.api.nvim_create_augroup("CmdlineAutocompletion", { clear = true }),
  callback = function(ev)
    if ev.event == "CmdlineChanged" and should_enable_autocomplete() then
      if not wildmode_set then
        vim.opt.wildmode = "noselect:lastused,full"
        wildmode_set = true
      end

      if not wild_timer then
        wild_timer = vim.uv.new_timer()
      else
        wild_timer:stop()
      end

      wild_timer:start(60, 0, function()
        vim.schedule(function()
          -- Only trigger if still in cmdline and we still match
          if vim.fn.mode() == "c" and should_enable_autocomplete() then
            pcall(vim.fn.wildtrigger)
          end
        end)
      end)
    end

    if ev.event == "CmdlineLeave" then
      if wild_timer then
        wild_timer:stop()
      end
      wildmode_set = false
      vim.opt.wildmode = "full"
    end
  end,
})

vim.keymap.set("n", "<leader>F", ":find<space>", { desc = "Fuzzy find" })

vim.keymap.set("c", "<m-e>", "<home><s-right><c-w>edit<end>", { desc = "Change command to :edit" })
vim.keymap.set("c", "<m-d>", function()
  if not is_cmdline_type_find() then
    vim.notify("This binding should be used with :find", vim.log.levels.ERROR)
    return
  end

  local cmdline_arg = vim.fn.split(vim.fn.getcmdline(), " ")[2]

  if vim.uv.fs_realpath(vim.fn.expand(cmdline_arg)) == nil then
    vim.notify("The second argument should be a valid path", vim.log.levels.ERROR)
    return
  end

  local keys =
    vim.api.nvim_replace_termcodes("<C-U>edit " .. vim.fs.dirname(cmdline_arg), true, true, true)
  vim.fn.feedkeys(keys, "c")
end, { desc = "Edit the dir for the path" })

vim.keymap.set("c", "<c-v>", "<home><s-right><c-w>vs<end>", { desc = "Change command to :vs" })
vim.keymap.set("c", "<c-s>", "<home><s-right><c-w>sp<end>", { desc = "Change command to :sp" })
vim.keymap.set("c", "<c-t>", "<home><s-right><c-w>tabe<end>", { desc = "Change command to :tabe" })
