require("mason").setup({
  ui  = {
    icons = {
      package_installed = "√",
      package_pending = "→",
      package_uninstalled = "×",
    },
  },

})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "bashls",
    "clangd",
    "cmake",
  },
})


local lspconfig = require('lspconfig')

require("mason-lspconfig").setup_handlers({
  function (server_name)
    require("lspconfig")[server_name].setup{}
  end,
  -- Next, you can provide targeted overrides for specific servers.
  ["lua_ls"] = function ()
    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }
          }
        }
    }
  }
  end,
  ["clangd"] = function ()
    lspconfig.clangd.setup {
      cmd = {
        "clangd",
        "--background-index",
        "-j=8",
        "--enable-config",
        "--all-scopes-completion",
        "--completion-style=bundled",
        "--enable-config",
        "--pretty",
        "--clang-tidy",
        "--log=verbose",
        "--header-insertion=iwyu",
        "--header-insertion-decorators",
        "--compile-commands-dir=${workspaceFolder}/build",
        "--query-driver=/usr/bin/clang++-14*",
        "--pch-storage=memory",
        "--malloc-trim",
      }
    }
  end
})
