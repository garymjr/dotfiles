local remap = require('core.utils').remap

require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
      function()
        return {
          exe = 'prettier',
          args = {'--stdin-filepath', vim.api.nvim_buf_get_name(0)},
          stdin = true
        }
      end
    }
  }
})

remap('n', 'gp', ':Format<cr>', { noremap = true })
