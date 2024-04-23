if false then
  MiniDeps.add({
    source = "catppuccin/nvim",
    name = "catppuccin",
  })

  MiniDeps.now(function()
    require("catppuccin").setup({
      term_colors = true,
      styles = {
        conditionals = {},
      },
      custom_highlights = function(colors)
        return {
          MiniCompletionActiveParameter = { style = { "underline" } },

          MiniCursorword = { style = { "underline" } },
          MiniCursorwordCurrent = { style = { "underline" } },

          MiniIndentscopeSymbol = { fg = colors.text },
          MiniIndentscopePrefix = { style = { "nocombine" } }, -- Make it invisible

          MiniJump = { fg = colors.overlay2, bg = colors.pink },

          MiniJump2dSpot = { bg = colors.base, fg = colors.peach, style = { "bold", "underline" } },

          MiniStarterCurrent = {},
          MiniStarterFooter = { fg = colors.yellow, style = { "italic" } },
          MiniStarterHeader = { fg = colors.blue },
          MiniStarterInactive = { fg = colors.surface2, style = { "italic" } },
          MiniStarterItem = { fg = colors.text },
          MiniStarterItemBullet = { fg = colors.blue },
          MiniStarterItemPrefix = { fg = colors.pink },
          MiniStarterSection = { fg = colors.flamingo },
          MiniStarterQuery = { fg = colors.green },

          MiniStatuslineDevinfo = { fg = colors.subtext1, bg = colors.surface1 },
          MiniStatuslineFileinfo = { fg = colors.subtext1, bg = colors.surface1 },
          MiniStatuslineFilename = { fg = colors.text, bg = colors.mantle },
          MiniStatuslineInactive = { fg = colors.blue, bg = colors.mantle },
          MiniStatuslineModeCommand = { fg = colors.base, bg = colors.peach, style = { "bold" } },
          MiniStatuslineModeInsert = { fg = colors.base, bg = colors.green, style = { "bold" } },
          MiniStatuslineModeNormal = { fg = colors.mantle, bg = colors.blue, style = { "bold" } },
          MiniStatuslineModeOther = { fg = colors.base, bg = colors.teal, style = { "bold" } },
          MiniStatuslineModeReplace = { fg = colors.base, bg = colors.red, style = { "bold" } },
          MiniStatuslineModeVisual = { fg = colors.base, bg = colors.mauve, style = { "bold" } },

          MiniSurround = { bg = colors.pink, fg = colors.surface1 },

          MiniTablineCurrent = { fg = colors.text, bg = colors.base, sp = colors.red, style = { "bold", "italic", "underline" } },
          MiniTablineFill = { bg = colors.base },
          MiniTablineHidden = { fg = colors.text, bg = colors.mantle },
          MiniTablineModifiedCurrent = { fg = colors.red, bg = colors.none, style = { "bold", "italic" } },
          MiniTablineModifiedHidden = { fg = colors.red, bg = colors.none },
          MiniTablineModifiedVisible = { fg = colors.red, bg = colors.none },
          MiniTablineTabpagesection = { fg = colors.surface1, bg = colors.base },
          MiniTablineVisible = { bg = colors.none },

          MiniTestEmphasis = { style = { "bold" } },
          MiniTestFail = { fg = colors.red, style = { "bold" } },
          MiniTestPass = { fg = colors.green, style = { "bold" } },

          MiniTrailspace = { bg = colors.red },
        }
      end,
      integrations = {
        mason = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = {},
            hints = { "italic" },
            warnings = {},
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
      },
    })

    vim.cmd.colorscheme("catppuccin")
  end)
end

if false then
  MiniDeps.add("rebelot/kanagawa.nvim")
  MiniDeps.now(function()
    require("kanagawa").setup({
      keywordStyle = { italic = false },
    })
    vim.cmd.colorscheme("kanagawa")
  end)
end

MiniDeps.add("mcauley-penney/ice-cave.nvim")
MiniDeps.now(function()
  vim.cmd.colorscheme("ice-cave")
end)
