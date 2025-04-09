-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set({ "n", "i", "v", "x" }, "<F1>", "", { silent = true, desc = "Disable F1" })
vim.keymap.set({ "n", "i", "v", "x" }, "<F2", "", { silent = true, desc = "Disable F2" })
vim.keymap.set({ "n", "i", "v", "x" }, "<F3>", "", { silent = true, desc = "Disable F3" })
vim.keymap.set({ "n", "i", "v", "x" }, "<F4>", "", { silent = true, desc = "Disable F4" })

vim.keymap.set("n", "<leader>cs", ":%s/\\s\\+$//e<CR>", { silent = true, desc = "Clean trailing spaces" })
vim.keymap.set("n", "<leader>ct", ": Trouble<CR>", { silent = true, desc = "Toggle Trouble" })
vim.keymap.set(
  "n",
  "<leader>cS",
  ": Trouble lsp_document_symbols toggle focus=false win.position=right<CR>",
  { silent = true, desc = "Toggle Symbols" }
)
