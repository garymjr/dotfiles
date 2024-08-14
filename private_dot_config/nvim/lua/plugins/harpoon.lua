require("mini.deps").add {
  source = "ThePrimeagen/harpoon",
  checkout = "harpoon2",
  depends = { "nvim-lua/plenary.nvim" },
}
require("mini.deps").later(function()
  require("harpoon").setup {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  }

  vim.keymap.set("n", "<leader>H", function()
    require("harpoon"):list():add()
  end, { desc = "[H]arpoon File" })

  vim.keymap.set("n", "<leader>h", function()
    local harpoon = require "harpoon"
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, { desc = "[H]arpoon Quick Menu" })

  for i = 1, 5 do
    vim.keymap.set("n", "<leader>" .. i, function()
      require("harpoon"):list():select(i)
    end, { desc = "Harpoon File [" .. i .. "]" })
  end
end)
