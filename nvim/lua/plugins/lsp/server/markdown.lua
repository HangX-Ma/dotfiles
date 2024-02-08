local server = {}
local common = require("plugins.lsp.server.common")
local opts = {
    marksman = {},
    capabilities = common.capabilities,
    on_attach = function(_, bufnr)
        common.keybindings(bufnr)
    end,
}

function server.checkOK()
    return vim.fn.executable("marksman") == 1
end


function server.setup()
    common.lspconfig.marksman.setup(opts)
end

return server
