local server = {}

function server.checkOK()
	return vim.fn.executable("clangd") == 1
end

function server.setup()
	local lspconfig = require("lspconfig")
	local common = require("plugins.lsp.server.common")
	local capabilities = vim.deepcopy(common.capabilities)
	capabilities.offsetEncoding = "utf-8"
	lspconfig.clangd.setup({
		cmd = {
			"clangd",
			"--background-index",
			"-j=12",
			"--all-scopes-completion",
			"--completion-style=bundled",
			"--enable-config",
			"--pretty",
			"--clang-tidy",
			"--log=verbose",
			"--header-insertion=iwyu",
			"--header-insertion-decorators",
			"--query-driver=/usr/bin/clang++-14*",
			"--pch-storage=memory",
			"--malloc-trim",
		},
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
			)(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname) or require(
				"lspconfig.util"
			).find_git_ancestor(fname)
		end,
		flags = common.lspflags,
		capabilities = capabilities,
		init_options = {
			semanticHighlighting = true,
			usePlaceholders = true,
			completeUnimported = true,
			clangdFileStatus = true, -- Provides information about activity on clangd’s per-file worker thread
		},
		filetypes = { "c", "cpp", "h", "ojbc", "objcpp", "cuda", "proto" },
	})
end

return server
