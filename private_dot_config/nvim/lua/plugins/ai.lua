return {
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.copilot = nil
      return opts
    end,
  },
}
