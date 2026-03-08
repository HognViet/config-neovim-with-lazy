-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.clipboard = "unnamedplus" -- share clipboard between neovim and window
vim.opt.encoding = "utf-8" -- the encoding written to a file
vim.opt.fileencoding = "utf-8" -- the encoding displayed
vim.opt.fileencodings = { "utf-8" } -- the encodings to try when reading a file
require("config.lazy")
require("lsp.clangd")
require("lsp.csharp")
-- notify when clangd is ready
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "clangd" then
      vim.notify(
        "✨ Clangd đã sẵn sàng!!!💖\n💖󰣐 Conffig LSP C# by HogngViet!!\n 󰙲 Clangd",
        { title = " C/C++ LSP" }
      )
    end
  end,
})