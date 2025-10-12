local server = {}

function server.checkOK()
	return vim.fn.executable("clangd") == 1
end

function server.setup()
	local common = require("plugin.lsp.server.common")
	local capabilities = vim.deepcopy(common.capabilities)
	local custom_attach = require("core.handlers").on_attach
	capabilities.offsetEncoding = { "utf-8", "utf-16" }
	capabilities.textDocument = { completion = { editsNearCursor = true } }
	local opts = {
		on_attach = custom_attach,
		cmd = {
			"clangd",
			"--background-index",
			"--background-index-priority=low",
			"-j=12",
			"--all-scopes-completion",
			"--completion-style=bundled",
			"--enable-config",
			"--pretty",
			"--clang-tidy",
			"--log=verbose",
			"--header-insertion=iwyu",
			"--header-insertion-decorators",
			"--query-driver=/usr/bin/clang++",
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
		filetypes = { "c", "cc", "cpp", "h", "hpp", "ojbc", "objcpp", "cuda", "proto" },
		settings = {
			clangd = {
				InlayHints = {
					Designators = true,
					Enabled = true,
					ParameterNames = true,
					DeducedTypes = true,
				},
				fallback_flags = { "-std=c++23" },
			},
		},
	}

	local v = vim.version()
	-- Check if Neovim is at least 0.11.0
	if v.major > 0 or (v.major == 0 and v.minor >= 11) then
		vim.lsp.config("clangd", opts)
	else
		local lspconfig = require("lspconfig")
		lspconfig.clangd.setup(opts)
	end
end

return server
