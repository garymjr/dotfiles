return {
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    opts = {
      -- linters = {},
      linters_by_ft = {
        elixir = { "credo" },
        markdown = { "markdownlint-cli2" },
        mysql = { "sqlfluff" },
        plsql = { "sqlfluff" },
        sql = { "sqlfluff" },
      },
    },
    config = function(_, opts)
      local lint = require "lint"
      -- require("lint").linters =
      --   vim.tbl_deep_extend("force", {}, require("lint").linters, opts.linters)
      lint.linters_by_ft = vim.tbl_deep_extend("force", {}, lint.linters_by_ft, opts.linters_by_ft)

      local H = {}

      function H.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        if not timer then
          return function(...) end
        end

        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function H.lint()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)
        names = vim.list_extend({}, names)
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          return linter ~= nil
        end, names)

        if #names > 0 then
          lint.try_lint(names)
        end
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = H.debounce(100, H.lint),
      })
    end,
  },
}
