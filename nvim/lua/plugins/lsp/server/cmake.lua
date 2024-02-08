-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#cmake
local server = {}
local common = require("plugins.lsp.server.common")
local opts = {
    root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
            'CMakePresets.json',
            'CTestConfig.cmake',
            '.git',
            'build',
            'cmake'
        )(fname)
    end,
    lspconfig = common.lspconfig,
    capabilities = common.capabilities,
    filetypes = { "cmake" },
    on_attach = function(bufnr)
        common.keybindings(bufnr)
    end,
}

function server.checkOK()
    return vim.fn.executable("cmake-language-server") == 1
end

function server.setup()
    common.lspconfig.cmake.setup(opts)
end

return server
