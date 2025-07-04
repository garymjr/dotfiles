return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    config = function(_, opts)
      require("render-markdown").setup(opts)

      vim.filetype.add {
        extension = { mdx = "markdown.mdx" },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "copilot-chat" },
        callback = function()
          vim.cmd "RenderMarkdown buf_enable"
        end,
      })
    end,
  },
}
