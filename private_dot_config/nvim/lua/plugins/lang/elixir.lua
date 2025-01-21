local H = {}

function H.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
end

return {
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        elixirls = {
          keys = {
            {
              "<leader>cp",
              function()
                local params = vim.lsp.util.make_position_params()
                H.execute({
                  command = "manipulatePipes:serverid",
                  arguments = {
                    "toPipe",
                    params.textDocument.uri,
                    params.position.line,
                    params.position.character,
                  },
                })
              end,
              desc = "To Pipe",
            },
            {
              "<leader>cP",
              function()
                local params = vim.lsp.util.make_position_params()
                H.execute({
                  command = "manipulatePipes:serverid",
                  arguments = {
                    "fromPipe",
                    params.textDocument.uri,
                    params.position.line,
                    params.position.character,
                  },
                })
              end,
              desc = "From Pipe",
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "elixir", "heex", "eex" })
      vim.treesitter.language.register("markdown", "livebook")

      vim.filetype.add({
        extension = {
          ex = "elixir",
        },
      })
    end,
  },
  {
    "nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = {
        elixir = { "credo" },
      }

      opts.linters = {
        credo = {
          condition = function(ctx)
            return vim.fs.find({ ".credo.exs" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      }
    end,
  },
  {
    "render-markdown.nvim",
    ft = function(_, ft)
      vim.list_extend(ft, { "livebook" })
    end,
  },
  {
    "markview.nvim",
    ft = function(_, ft)
      vim.list_extend(ft, { "livebook" })
    end,
  },
}
