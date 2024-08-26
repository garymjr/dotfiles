MiniDeps.add("mrjones2014/smart-splits.nvim")
MiniDeps.later(function()
  require("smart-splits").setup()

  vim.keymap.set("n", "<c-h>", function()
    require('smart-splits').move_cursor_left()
  end)

  vim.keymap.set("n", "<c-j>", function()
    require('smart-splits').move_cursor_down()
  end)

  vim.keymap.set("n", "<c-k>", function()
    require('smart-splits').move_cursor_up()
  end)

  vim.keymap.set("n", "<c-l>", function()
    require('smart-splits').move_cursor_right()
  end)
end)
