local Util = require "config.util"

local function augroup(name)
  return vim.api.nvim_create_augroup("minivim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup "checktime",
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd "checktime" end
  end,
})

-- Highlight on yank
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   group = augroup("highlight_yank"),
--   callback = function()
--     vim.highlight.on_yank()
--   end,
-- })

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup "resize_splits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd "tabdo wincmd ="
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "close_with_q",
  pattern = {
    "PlenaryTestPopup",
    "grug-far",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns.blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "wrap_spell",
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup "json_conceal",
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup "auto_create_dir",
  callback = function(event)
    if event.match:match "^%w%w+:[\\/][\\/]" then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.filetype.add {
  pattern = {
    [".*"] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= "bigfile"
            and path
            and vim.fn.getfsize(path) > vim.g.bigfile_size
            and "bigfile"
          or nil
      end,
    },
  },
}

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup "bigfile",
  pattern = "bigfile",
  callback = function(ev)
    vim.b.minianimate_disable = true
    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match { buf = ev.buf } or ""
    end)
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup "lsp_attach",
  callback = function(event)
    vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info", buffer = event.buf })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = event.buf })
    vim.keymap.set(
      "n",
      "gK",
      vim.lsp.buf.signature_help,
      { desc = "Signature Help", buffer = event.buf }
    )
    vim.keymap.set(
      "i",
      "<c-k>",
      vim.lsp.buf.signature_help,
      { desc = "Signature Help", buffer = event.buf }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>ca",
      vim.lsp.buf.code_action,
      { desc = "Code Action", buffer = event.buf }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>cc",
      vim.lsp.codelens.run,
      { desc = "Run Codelens", buffer = event.buf }
    )
    vim.keymap.set(
      "n",
      "<leader>cC",
      vim.lsp.codelens.refresh,
      { desc = "Refresh & Display Codelens", buffer = event.buf }
    )
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename", buffer = event.buf })
    vim.keymap.set("n", "<leader>cA", function()
      vim.lsp.buf.code_action {
        apply = true,
        context = {
          only = { "source" },
          diagnostics = {},
        },
      }
    end, { desc = "Source Action", buffer = event.buf })

    vim.keymap.set(
      "n",
      "gd",
      "<cmd>Pick lsp scope='definition'<cr>",
      { desc = "Goto Definition", silent = true }
    )
    vim.keymap.set(
      "n",
      "gr",
      "<cmd>Pick lsp scope='references'<cr>",
      { desc = "References", nowait = true, silent = true }
    )
    vim.keymap.set(
      "n",
      "gI",
      "<cmd>Pick lsp scope='implementation'<cr>",
      { desc = "Goto Implementation", silent = true }
    )
    vim.keymap.set(
      "n",
      "gy",
      "<cmd>Pick lsp scope='type_definition'<cr>",
      { desc = "Goto T[y]pe Definition", silent = true }
    )
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("gwm_lsp_completion", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then return end

    -- Enable completion and configure keybindings.
    if client.supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })

      -- Use enter to accept completions.
      vim.keymap.set("i", "<cr>", function()
        return Util.pumvisible() and "<C-y>" or "<cr>"
      end, { expr = true })

      -- Use slash to dismiss the completion menu.
      vim.keymap.set("i", "/", function()
        return Util.pumvisible() and "<C-e>" or "/"
      end, { expr = true })

      -- Use <C-n> to navigate to the next completion or:
      -- - Trigger LSP completion.
      -- - If there's no one, fallback to vanilla omnifunc.
      vim.keymap.set("i", "<C-n>", function()
        if Util.pumvisible() then
          Util.feedkeys "<C-n>"
        else
          if next(vim.lsp.get_clients { bufnr = 0 }) then
            vim.lsp.completion.trigger()
          else
            if vim.bo.omnifunc == "" then
              Util.feedkeys "<C-x><C-n>"
            else
              Util.feedkeys "<C-x><C-o>"
            end
          end
        end
      end, { desc = "Trigger/select next completion" })

      -- Buffer completions.
      vim.keymap.set("i", "<C-u>", "<C-x><C-n>", { desc = "Buffer completions" })

      -- Use <Tab> to accept a Copilot suggestion, navigate between snippet tabstops,
      -- or select the next completion.
      -- Do something similar with <S-Tab>.
      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if vim.snippet.active { direction = 1 } then
          vim.snippet.jump(1)
        else
          Util.feedkeys "<Tab>"
        end
      end, { expr = true })

      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if vim.snippet.active { direction = -1 } then
          vim.snippet.jump(-1)
        else
          Util.feedkeys "<S-Tab>"
        end
      end, { expr = true })

      -- Inside a snippet, use backspace to remove the placeholder.
      vim.keymap.set("s", "<BS>", "<C-o>s")
    end
  end,
})
