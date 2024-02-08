local server = {}
local common = require("plugins.lsp.server.common")
local opts = {
    capabilities = common.capabilities,
    on_attach = function(bufnr)
        common.keybindings(bufnr)
    end,
}

function server.checkOK()
    return vim.fn.executable("bash-language-server") == 1
end

function server.setup()
    common.lspconfig.bashls.setup(opts)
end

return server
