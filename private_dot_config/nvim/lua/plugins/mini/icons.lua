require("mini.deps").later(function()
  require("mini.icons").setup {
    file = {
      [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
    },
  }

  package.preload["nvim-web-devicons"] = function()
    require("mini.icons").mock_nvim_web_devicons()
    return package.loaded["nvim-web-devicons"]
  end
end)
