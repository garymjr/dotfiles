local U = require('snippets.utils')

require('snippets').snippets = {
  _global = {
    todo = U.force_comment [[TODO: ]]
  },
  javascript = {
    imd = [[import { $2 } from '${1:package}';]],
    imp = [[import ${2:$1} from '${1:package}';]]
  }
}

-- require('snippets').use_suggested_mappings()

local M = {}

M.snippet_available = function()
  local _, snippet = require('snippets').lookup_snippet_at_cursor()
  local has_active_snippet = require('snippets').has_active_snippet()
  if snippet or has_active_snippet then
    return true
  end
  return false
end

return M
