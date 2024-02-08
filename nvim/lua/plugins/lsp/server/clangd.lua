local server = {}
local common = require("plugins.lsp.server.common")
local opts = {
    root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
           ".clangd",
           ".clang-tidy",
           ".clang-format",
           "Makefile",
           "configure.ac",
           "configure.in",
           "config.h.in",
           "meson.build",
           "meson_options.txt",
           "build.ninja"
        )(fname)
        or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname)
        or require("lspconfig.util").find_git_ancestor(fname)
    end,
    lspconfig = common.lspconfig,
    capabilities = common.capabilities,
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
    filetypes = { "c", "cpp", "h", "ojbc", "objcpp", "cuda", "proto" },
    on_attach = function(bufnr)
        common.keybindings(bufnr)
    end,
}

function server.checkOK()
    return vim.fn.executable("clangd") == 1
end

function server.setup()
    common.lspconfig.clangd.setup(opts)
end

return server
