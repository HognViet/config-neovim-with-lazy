-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Neo-tree toggle với F2
-- Map Neo-tree toggle
--vim.keymap.set("n", "<F2>", function()
--  require("nvim-tree.api").tree.toggle()
--end, { desc = "Toggle File Tree" })

local map = vim.keymap.set

-- FIX <leader>fg: luôn dùng ripgrep, không qua git/snacks
map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, { desc = "Live Grep (rg)" })
-- FIX <leader>fb: luôn dùng buffers, không qua snacks
map("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "Buffers" })

-- Toggleterm keymaps
vim.keymap.set('n', '<F4>', '<cmd>ToggleTerm direction=float<cr>', { desc = 'Toggle floating terminal' })
vim.keymap.set('t', '<F4>', '<cmd>ToggleTerm<cr>', { desc = 'Toggle floating terminal' })

-- Function cho terminal mappings (theo ĐÚNG documentation)
-- Terminal navigation - Ctrl+Arrow keys (CHẮC CHẮN HOẠT ĐỘNG)
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*toggleterm#*",
  callback = function()
    local opts = { buffer = 0, noremap = true, silent = true }
    
    -- Esc hoặc jk để thoát terminal mode
    vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    
    -- Ctrl+Arrow keys để DI CHUYỂN (không cần Esc)
    vim.keymap.set('t', '<C-Left>', [[<C-\><C-n><C-w>h]], opts)   -- Ctrl+← → trái
    vim.keymap.set('t', '<C-Down>', [[<C-\><C-n><C-w>j]], opts)   -- Ctrl+↓ → dưới
    vim.keymap.set('t', '<C-Up>', [[<C-\><C-n><C-w>k]], opts)     -- Ctrl+↑ → trên
    vim.keymap.set('t', '<C-Right>', [[<C-\><C-n><C-w>l]], opts)  -- Ctrl+→ → phải
    
    -- Bonus: Ctrl+hjkl trong normal mode
    vim.keymap.set('n', '<C-h>', [[<C-w>h]], opts)
    vim.keymap.set('n', '<C-j>', [[<C-w>j]], opts)
    vim.keymap.set('n', '<C-k>', [[<C-w>k]], opts)
    vim.keymap.set('n', '<C-l>', [[<C-w>l]], opts)
  end,
})

-- LSP keymaps
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  
  -- QUAN TRỌNG: Xóa mapping cũ trước khi map lại
  vim.keymap.del('n', 'gd', { buffer = bufnr })
  vim.keymap.del('n', 'gr', { buffer = bufnr })
  vim.keymap.del('n', 'gi', { buffer = bufnr })
  
  -- Rồi map lại
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

-- DAP: F10 = Step Into, F11 = Step Out
vim.keymap.set("n", "<F10>", function() require("dap").step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<F11>", function() require("dap").step_out() end, { desc = "Step Out" })