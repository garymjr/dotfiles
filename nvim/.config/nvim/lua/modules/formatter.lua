local remap = require('core.utils').remap

require('formatter').setup({
  logging = false,
  filetype = {
    javascript = {
      function()
        return {
          exe = 'prettier',
          args = {
            '--single-quote',
            '--trailing-comma', 'none',
            '--arrow-parens', 'avoid',
            '--stdin-filepath', vim.api.nvim_buf_get_name(0)},
          stdin = true
        }
      end
    },
    typescript = {
      function()
        return {
          exe = 'prettier',
          args = {
            '--single-quote',
            '--trailing-comma', 'none',
            '--arrow-parens', 'avoid',
            '--stdin-filepath', vim.api.nvim_buf_get_name(0)},
          stdin = true
        }
      end
    },
    json = {
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
