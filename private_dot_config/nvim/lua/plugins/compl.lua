require("mini.deps").add "brianaung/compl.nvim"
require("mini.deps").later(function()
  require("compl").setup()

  vim.keymap.set("i", "<cr>", function()
    if vim.fn.complete_info()["selected"] ~= -1 then return "<c-y>" end
    if vim.fn.pumvisible() ~= 0 then return "<c-e><cr>" end
    return "<cr>"
  end, { expr = true })
end)
