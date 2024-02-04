local status, mason = pcall(require, "mason")
if not status then
  vim.notify("cannot find mason")
  return
end

local status, mason_config = pcall(require, "mason-lspconfig")
if not status then
  vim.notify("cannot find mason-lspconfig")
  return
end

local status, lspconfig = pcall(require, "lspconfig")
if not status then
  vim.notify("cannot find lspconfig")
  return
end

require("mason").setup({
    ui = {
        icons = {
            package_installed = "√",
            package_pending = "→",
            package_uninstalled = "×",
        },
    },

})

require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "clangd",
        "cmake",
    },
})

-- https://github.com/williamboman/nvim-lsp-installer#available-lsps
local servers = {
  bashls = require("lsp.config.bash"),
  clangd = require("lsp.config.clangd"),
  cmake = require("lsp.config.cmake"),
  lua_ls = require("lsp.config.lua"), -- lua/lsp/config/lua.lua
  marksman = require("lsp.config.markdown"),
}

for name, config in pairs(servers) do
  if config ~= nil and type(config) == "table" then
    config.on_setup(lspconfig[name])
  else
    lspconfig[name].setup({})
  end
end

require("lsp.ui")
