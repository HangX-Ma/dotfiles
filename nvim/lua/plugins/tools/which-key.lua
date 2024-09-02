return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeoutlen = 300
		vim.o.timeout = true
	end,
	dependencies = {
		"echasnovski/mini.icons",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local which_key = require("which-key")
		local setup = {
			preset = "modern",
			plugins = {
				marks = true, -- shows a list of your marks on ' and `
				registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
				spelling = {
					enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
					suggestions = 20, -- how many suggestions should be shown in the list?
				},
				-- the presets plugin, adds help for a bunch of default keybindings in Neovim
				-- No actual key bindings are created
				presets = {
					operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
					motions = true, -- adds help for motions
					text_objects = true, -- help for text objects triggered after entering an operator
					windows = true, -- default bindings on <c-w>
					nav = true, -- misc bindings to work with windows
					z = true, -- bindings for folds, spelling and others prefixed with z
					g = true, -- bindings for prefixed with g
				},
			},
			layout = {
				height = { min = 4, max = 25 }, -- min and max height of the columns
				width = { min = 20, max = 50 }, -- min and max width of the columns
				spacing = 3, -- spacing between columns
				align = "left", -- align columns left, center or right
			},
			show_help = true, -- show help message on the command line when the popup is visible
			show_keys = true, -- show the currently pressed key and its label as a message in the command line
			triggers = {
				{ "<auto>", mode = "nixsotc" },
				{ "a", mode = { "n", "v" } },
			},
		}

		which_key.setup(setup)
		which_key.add({
			-- NORMAL mode
			mode = "n",
			prefix = "",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
			expr = false, -- use `expr` when creating keymaps

			-- vim basic
			{ "<leader>nh", desc = "No Highlights", hidden = true },
			{ "<leader>q", desc = "Quit", hidden = true },
			{ "<leader>Q", desc = "Quit All", hidden = true },
			{ "<leader>b", desc = "Spider b", hidden = true },
			{ "<leader>e", desc = "Spider e", hidden = true },
			{ "<leader>w", desc = "Spider w", hidden = true },
			{ "<leader>W", group = "Window" },
			{ "<leader>Wh", desc = "<cmd>:sp<CR>", "Spilt Horizontal" },
			{ "<leader>Wv", desc = "<cmd>:vsp<CR>", "Spilt Vertical" },
			{ "g", group = "General" },
			{ "gd", "<cmd>Lspsaga goto_definition<cr>", desc = "Goto Definitions" },
			{ "gp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definitions" },
			{ "gh", "<cmd>Lspsaga hover_doc<cr>", desc = "Give me Hint!" },
			{ "ga", "<cmd>Lspsaga code_action<cr>", desc = "Code Action" },
			{ "gA", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "LSP Code Action" },
			{ "gi", "<cmd>Lspsaga incoming_calls<cr>", desc = "Callee Functions" },
			{ "go", "<cmd>Lspsaga outgoing_calls<cr>", desc = "Called Functions" },
			{ "gr", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
			{ "gs", "<cmd>Lspsaga finder<cr>", desc = "Search" },

			-- Doge
			{ "gD", group = "Doge" },
			{ "gDc", desc = "Generate Comment" },
			{ "gDt", desc = "Trigger Doge" },
			-- GotoPreview
			{ "<leader>P", group = "GotoPreview" },
			{ "<leader>Pd", "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", desc = "Definition" },
			{
				"<leader>Pt",
				"<cmd>lua require('goto-preview').goto_preview_type_definition()<cr>",
				desc = "Type Definition",
			},
			{
				"<leader>Pi",
				"<cmd>lua require('goto-preview').goto_preview_implementation()<cr>",
				desc = "Implementation",
			},
			{
				"<leader>PD",
				"<cmd>lua require('goto-preview').goto_preview_declaration()<cr>",
				desc = "Declaration",
			},
			{ "<leader>Pc", "<cmd>lua require('goto-preview').close_all_win()<cr>", desc = "Close Windows" },
			{
				"<leader>Pr",
				"<cmd>lua require('goto-preview').goto_preview_references()<cr>",
				desc = "References",
			},

			-- yazi
			{ "<leader>-", desc = "Yazi" },
			-- bufferline
			{ "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Goto Tab1" },
			{ "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Goto Tab2" },
			{ "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Goto Tab3" },
			{ "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Goto Tab4" },
			{ "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Goto Tab5" },
			-- File
			{ "<leader>f", group = "File" },
			{ "<leader>fb", "<cmd>Telescope file_browser<CR>", desc = "File Browser" },
			{ "<leader>fB", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Buffers(All)" },
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files(Root)" },
			{ "<leader>fF", "<cmd>Telescope find_files<cr> cwd=true", desc = "Find Files(CWD)" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent Files" },
			{ "<leader>fm", desc = "Format File" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Tags" },
			{ "<leader>fH", "<cmd>Telescope highlights<CR>", desc = "Highlights" },
			{ "<leader>fg", desc = "Grep in open files" },
			{ "<leader>fw", desc = "Search word in open files" },
			{ "<leader>fo", "<cmd>Telescope smart_open<CR>", desc = "Smart Open(Root)" },
			{
				"<leader>fO",
				"<cmd>lua require('telescope').extensions.smart_open.smart_open({cwd_only = true,})<CR>",
				desc = "Smart Open(CWD)",
			},
			-- File -> LSP
			{ "<leader>fl", group = "LSP" },
			{ "<leader>flr", "<cmd>Telescope lsp_references<CR>", desc = "References" },
			{ "<leader>fli", "<cmd>Telescope lsp_incoming_calls<CR>", desc = "Incoming Calls" },
			{ "<leader>flo", "<cmd>Telescope lsp_outgoing_calls<CR>", desc = "Outgoing Calls" },
			{ "<leader>fld", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document Symbols(Buffer)" },
			{ "<leader>fla", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "Diagonostics(CWD)" },
			{ "<leader>flA", "<cmd>Telescope diagnostics<CR>", desc = "Diagonostics(Root)" },
			{ "<leader>flw", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Document Symbols(CWD)" },
			{ "<leader>flW", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Document Symbols(Dynamic)" },
			{ "<leader>flI", "<cmd>Telescope lsp_implementations<CR>", desc = "Implementation" },
			{ "<leader>flD", "<cmd>Telescope lsp_definitions<CR>", desc = "Definitions" },
			{ "<leader>flT", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Type Definitions" },
			-- File -> Search
			{ "<leader>fs", group = "Search" },
			{ "<leader>fsa", desc = "Auto Commands" },
			{ "<leader>fsb", desc = "Buffer(Fuzzy)" },
			{ "<leader>fsc", desc = "Command History" },
			{ "<leader>fsC", desc = "Commands" },
			{ "<leader>fsd", desc = "Diagonostics" },
			{ "<leader>fsg", desc = "Grep(CWD)" },
			{ "<leader>fsG", desc = "Grep(Buffer)" },
			{ "<leader>fsj", desc = "Jumplist" },
			{ "<leader>fsk", desc = "Keymaps" },
			{ "<leader>fsm", desc = "Jump to Marks" },
			{ "<leader>fsM", desc = "Man Pages" },
			{ "<leader>fso", desc = "Vim Options" },
			{ "<leader>fsq", desc = "QuickFix" },
			{ "<leader>fsi", desc = "Telescope Builtins" },
			{ "<leader>fst", "<cmd>TodoTelescope<cr>", desc = "TodoTelescope" },
			{ "<leader>fsT", desc = "Tags" },
			{ "<leader>fss", desc = "Document Symbols" },
			{ "<leader>fsS", desc = "Workspace Symbols" },
			{ "<leader>fsw", desc = "Word(CWD)" },
			{ "<leader>fsW", desc = "Word(Buffer)" },
			-- File -> Wrapping
			{ "<leader>fR", group = "Wrapping" },
			{ "<leader>fRs", "<cmd>lua require('wrapping').soft_wrap_mode()<cr>", desc = "Soft Wrap Mode" },
			{ "<leader>fRh", "<cmd>lua require('wrapping').hard_wrap_mode()<cr>", desc = "Hard Wrap Mode" },
			{ "<leader>fRt", "<cmd>lua require('wrapping').toggle_wrap_mode()<cr>", desc = "Toggle Wrap Mode" },
			-- File -> linter
			{ "<leader>fL", "<cmd>lua require('lint').try_lint()<cr>", desc = "Trigger linting" },

			-- Terminal/Tab
			{ "<leader>t", group = "Terminal/Tab" },
			{ "<leader>tf", desc = "Terminal Float" },
			{ "<leader>th", desc = "Terminal Horizontal" },
			{ "<leader>tv", desc = "Terminal Vertical " },
			{ "<leader>tg", desc = "Lazy Git" },
			{ "<leader>tn", desc = "ncdu" },
			{ "<leader>tt", desc = "htop" },
			{ "<leader>tj", desc = "Goto Next Tab" },
			{ "<leader>tk", desc = "Goto Previous Tab" },
			{ "<leader>tp", desc = "Pick Tab" },
			{ "<leader>td", desc = "Close Tab" },
			{ "<leader>tc", group = "Close" },
			-- Terminal/Tab -> Close Tab
			{ "<leader>tcp", desc = "Pick And Close Tab" },
			{ "<leader>tco", desc = "Close Other Tabs" },
			{ "<leader>tcl", desc = "Close Left Tab" },
			{ "<leader>tcr", desc = "Close Right Tab" },

			-- Git
			{ "<leader>g", group = "Git" },
			{ "<leader>gf", "<cmd>DiffviewFileHistory<CR>", desc = "File History" },
			{ "<leader>gp", "<cmd>DiffviewOpen<CR>", desc = "Diff Project" },
			{ "<leader>gn", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk" },
			{ "<leader>gN", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk" },
			{ "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame" },
			{ "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
			{ "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
			{ "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk" },
			{ "<leader>gS", "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", desc = "Stage Hunk" },
			{ "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
			{ "<leader>gU", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
			{ "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
			{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
			{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
			{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },

			-- Lspsaga, diagonostics
			{ "<leader>a", group = "Diagonostics" },
			{ "<leader>ab", "<cmd>Lspsaga show_buf_diagnostics<cr>", desc = "Buffer Diagonostics" },
			{
				"<leader>al",
				"<cmd>Lspsaga show_line_diagnostics<cr>",
				desc = "Line Diagonostics",
			},
			{
				"<leader>ac",
				"<cmd>Lspsaga show_cursor_diagnostics<cr>",
				desc = "Cursor Diagonostics",
			},
			{
				"<leader>aw",
				"<cmd>Lspsaga show_workspace_diagnostics<cr>",
				desc = "Workspace Diagonostics",
			},
			{
				"<leader>ap",
				"<cmd>Lspsaga diagnostic_jump_prev<cr>",
				desc = "Previous Diagonostics",
			},
			{
				"<leader>an",
				"<cmd>Lspsaga diagnostic_jump_next<cr>",
				desc = "Next Diagonostics",
			},
			-- Dap
			{ "<leader>d", group = "Dap" },
			{ "<leader>dB", desc = "BreakPoint Condition" },
			{ "<leader>db", desc = "Toggle BreakPoint" },
			{ "<leader>dc", desc = "Continue " },
			{ "<leader>dC", desc = "Run to Cursor" },
			{ "<leader>da", desc = "Run with Args" },
			{ "<leader>dl", desc = "Run Last" },
			{ "<leader>dg", desc = "Goto line (on execute)" },
			{ "<leader>dp", desc = "Pause" },
			{ "<leader>ds", desc = "Session " },
			{ "<leader>dr", desc = "Toggle REPL" },
			{ "<leader>do", desc = "Step Out" },
			{ "<leader>dO", desc = "Step Over" },
			{ "<leader>di", desc = "Step Into" },
			{ "<leader>dj", desc = "Down" },
			{ "<leader>dk", desc = "Up" },
			{ "<leader>dw", desc = "Widgets" },
			{ "<leader>du", desc = "Dap UI" },
			{ "<leader>de", desc = "Dap Eval " },

			-- Neotest
			{ "<leader>v", group = "Neotest" },
			{ "<leader>va", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach Nearest" },
			{ "<leader>vd", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Nearest" },
			{ "<leader>vt", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run File" },
			{ "<leader>vT", "<cmd>lua require('neotest').run.run(vim.uv.cwd())<cr>", desc = "Run All Test Files" },
			{ "<leader>vr", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run Nearest" },
			{ "<leader>vl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Run Last" },
			{ "<leader>vs", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle Summary" },
			{
				"<leader>vo",
				"<cmd>lua require('neotest').output.open({ enter = true, auto_close = true })<cr>",
				desc = "Show Output",
			},
			{ "<leader>vO", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Toggle Output Panel" },
			{ "<leader>vS", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop" },

			-- CscopeMaps
			{ "<leader>m", group = "CscopeMaps" },
			{ "<leader>ms", desc = "Find all references" },
			{ "<leader>mg", desc = "Find global definition(s)" },
			{ "<leader>mc", desc = "Find all calls to the function name" },
			{ "<leader>mt", desc = "Find all instances of the text" },
			{ "<leader>me", desc = "egrep search for the word" },
			{ "<leader>mf", desc = "Open the filename" },
			{ "<leader>mi", desc = "Find files that include the filename" },
			{ "<leader>md", desc = "Find functions that function calls" },
			{ "<leader>ma", desc = "Find places where symbol assigned a value" },
			{ "<leader>mb", desc = "Build cscope database" },

			-- LSP
			{ "<leader>k", group = "LSP" },
			{ "<leader>kt", desc = "Toggle Signature" },
			{ "<leader>kh", desc = "Hover LSP Info" },
			{ "<leader>kq", desc = "Quit LSP Floating Windows" },

			-- Rust
			{ "<leader>r", group = "Rust" },
			{ "<leader>rD", "<cmd>RustLsp debuggables<cr>", desc = "Rust Debuggables" },
			{ "<leader>rR", "<cmd>RustLsp runnables<cr>", desc = "Rust Runnables" },
			{ "<leader>rT", "<cmd>RustLsp testables<cr>", desc = "Rust Testables" },
			{ "<leader>re", "<cmd>RustLsp expandMacro<cr>", desc = "Expand Macro" },
			{ "<leader>rb", "<cmd>RustLsp rebuildProcMacros<cr>", desc = "Rebuild ProcMacros" },
			{ "<leader>ru", "<cmd>RustLsp moveItem up<cr>", desc = "Move item up" },
			{ "<leader>rd", "<cmd>RustLsp moveItem down<cr>", desc = "Move item down" },
			{ "<leader>ra", "<cmd>RustLsp codeAction<cr>", desc = "Code Action" },
			{ "<leader>rh", "<cmd>RustLsp hover actions<cr>", desc = "Hover Actions" },
			{ "<leader>rn", "<cmd>RustLsp hover range<cr>", desc = "Hover Range" },
			{ "<leader>rE", "<cmd>RustLsp explainError<cr>", desc = "Explain Error" },
			{ "<leader>rr", "<cmd>RustLsp renderDiagnostic<cr>", desc = "Render Diagnostic" },
			{ "<leader>ro", "<cmd>RustLsp openCargo<cr>", desc = "Open cargo" },
			{ "<leader>rO", "<cmd>RustLsp openDocs<cr>", desc = "Open docs.rs documentation" },
			{ "<leader>rp", "<cmd>RustLsp parentModule<cr>", desc = "Rust parent module" },
			{ "<leader>rj", "<cmd>RustLsp joinLines<cr>", desc = "Join lines" },
			{ "<leader>rS", "<cmd>RustLsp ssr<cr>", desc = "Structural search Replace" },
			{ "<leader>rg", "<cmd>RustLsp crateGraph<cr>", desc = "View create graph" },
			{ "<leader>rt", "<cmd>RustLsp syntaxTree<cr>", desc = "Rust syntax tree" },
			{ "<leader>rv", "<cmd>RustLsp view hir<cr>", desc = "View rust HIR" },
			{ "<leader>rV", "<cmd>RustLsp vim mir<cr>", desc = "View rust MIR" },
			-- Rust -> workspace symbol
			{ "<leader>rs", group = "WorkspaceSymbol" },
			{ "<leader>rst", "<cmd>RustLsp workspaceSymbol onlyTypes<cr>", desc = "Only type symbols" },
			{ "<leader>rsa", "<cmd>RustLsp workspaceSymbol allSymbols<cr>", desc = "Show all symbols" },
			-- Rust -> FlyCheck
			{ "<leader>rf", group = "FlyCheck" },
			{ "<leader>rfr", "<cmd>RustLsp flyCheck run<cr>", desc = "Run check" },
			{ "<leader>rfc", "<cmd>RustLsp flyCheck clear<cr>", desc = "Clear check" },
			{ "<leader>rfn", "<cmd>RustLsp flyCheck cancel<cr>", desc = "Cancel check" },
			-- Crates
			{ "<leader>c", group = "Crates" },
			{ "<leader>ct", "<cmd>lua require('crates').toggle()<cr>", desc = "Toggle" },
			{ "<leader>cr", "<cmd>lua require('crates').reload()<cr>", desc = "Reload" },
			{ "<leader>cv", "<cmd>lua require('crates').show_versions_popup()<cr>", desc = "Show versions" },
			{ "<leader>cf", "<cmd>lua require('crates').show_features_popup()<cr>", desc = "Show features" },
			{ "<leader>cd", "<cmd>lua require('crates').show_dependencies_popup<cr>", desc = "Show dependencies" },
			{ "<leader>ca", "<cmd>lua require('crates').update_all_crates<cr>", desc = "Update all crates" },
			{ "<leader>cA", "<cmd>lua require('crates').upgrade_all_crates()<cr>", desc = "Upgrade all crates" },
			{
				"<leader>cx",
				"<cmd>lua require('crates').expand_plain_crate_to_inline_table()<cr>",
				desc = "Expand plain create to inline table",
			},
			{
				"<leader>cX",
				"<cmd>lua require('crates').extract_crate_into_table()<cr>",
				desc = "Extract create into table",
			},
			{ "<leader>cH", "<cmd>lua require('crates').open_homepage()<cr>", desc = "Open homepage" },
			{ "<leader>cR", "<cmd>lua require('crates').open_repository()<cr>", desc = "Open repository" },
			{ "<leader>cD", "<cmd>lua require('crates').open_documentation()<cr>", desc = "Open documentation" },
			{ "<leader>cC", "<cmd>lua require('crates').open_crates_io()<cr>", desc = "Open crates io" },
			{ "<leader>cu", "<cmd>lua require('crates').update_crate()<cr>", desc = "Update create" },
			{ "<leader>cU", "<cmd>lua require('crates').upgrade_crate()<cr>", desc = "Upgrade create" },
		})

		which_key.add({
			mode = { "v" },
			prefix = "",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
			expr = false, -- use `expr` when creating keymaps
			{ "<leader>cu", "<cmd>lua require('crates').update_crate()<cr>", desc = "Update create" },
			{ "<leader>cU", "<cmd>lua require('crates').upgrade_crate()<cr>", desc = "Upgrade create" },
		})
	end,
}
