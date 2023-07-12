local maps = {
    {
        "n",
        "<cr>",
        [[{-> v:hlsearch ? ":nohl<cr>" : "<cr>"}()]],
        { expr = true, silent = true },
    },
    {"n", "j", "gj", { silent = true }},
    {"n", "k", "gk", { silent = true }},
    {"n", "<backspace>", "<c-^>", { silent = true }},
    {"n", "<leader>gm", "<cmd>GitMessenger<cr>", { silent = true }},
    {"n", "<leader>l", "<cmd>Lazy<cr>", { silent = true }},
    {"n", "<leader>q", "<cmd>bd<cr>", { silent = true }},
    {"n", "gh", "_", { silent = true }},
    {"n", "gl", "$", { silent = true }},
    {"n", "<leader>d", vim.diagnostic.open_float, { silent = true }},
    {"n", "<leader>q", vim.diagnostic.setloclist, { silent = true }},
    {"n", "[d", vim.diagnostic.goto_prev, { silent = true }},
    {"n", "]d", vim.diagnostic.goto_next, { silent = true }},
    {{"n", "v"}, "<leader>y", [["+y]], { silent = true }},
    {{"n", "v"}, "<leader>Y", [["+y$]], { silent = true }},
    {{"n", "v"}, "<leader>p", [["+p]], { silent = true }},
    {{"n", "v"}, "<leader>P", [["+P]], { silent = true }},
    {"v", "<", "<gv", { noremap = false, silent = true }},
    {"v", ">", ">gv", { noremap = false, silent = true }},
    {"v", "J", ":m '>+1<CR>gv=gv", { silent = true }},
    {"v", "K", ":m '<-2<CR>gv=gv", { silent = true }},
    {"t", "<esc>", [[<c-\><c-n>]], { silent = true }},
}

vim.api.nvim_command("cabbrev we w")
vim.api.nvim_command("cabbrev we w")

for _, map in ipairs(maps) do
    vim.keymap.set(map[1], map[2], map[3], map[4])
end
