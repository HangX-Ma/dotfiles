return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeoutlen = 300
		vim.o.timeout = true
	end,
	config = function()
		local which_key = require("which-key")
		local setup = {
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
			-- add operators that will trigger motion and text object completion
			-- to enable all native operators, set the preset / operators plugin above
			operators = {
				gc = "Comments",
				gb = "Comments",
			},
			key_labels = {
				-- override the label used to display some keys. It doesn't effect WK in any other way.
				-- For example:
				-- ["<space>"] = "SPC",
				-- ["<cr>"] = "RET",
				-- ["<tab>"] = "TAB",
			},
			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "➜", -- symbol used between a key and it's label
				group = "+", -- symbol prepended to a group
			},
			popup_mappings = {
				scroll_down = "<c-d>", -- binding to scroll down inside the popup
				scroll_up = "<c-u>", -- binding to scroll up inside the popup
			},
			window = {
				border = "rounded", -- none, single, double, shadow
				position = "bottom", -- bottom, top
				margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
				padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
				winblend = 0,
			},
			layout = {
				height = { min = 4, max = 25 }, -- min and max height of the columns
				width = { min = 20, max = 50 }, -- min and max width of the columns
				spacing = 3, -- spacing between columns
				align = "left", -- align columns left, center or right
			},
			ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
			hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
			show_help = true, -- show help message on the command line when the popup is visible
			show_keys = true, -- show the currently pressed key and its label as a message in the command line
			triggers = "auto", -- automatically setup triggers
			-- triggers = {"<leader>"}, -- or specify a list manually
			-- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
			triggers_nowait = {
				-- marks
				"`",
				"'",
				"g`",
				"g'",
				-- registers
				'"',
				"<c-r>",
				-- spelling
				"z=",
			},
			-- triggers = {"<leader>"} -- or specify a list manually
			triggers_blacklist = {
				-- list of mode / prefixes that should never be hooked by WhichKey
				-- this is mostly relevant for key maps that start with a native binding
				-- most people should not need to change this
				i = { "j", "k" },
				v = { "j", "k" },
				t = { "<leader>" },
			},
		}

		local normal_opts = {
			mode = "n", -- NORMAL mode
			prefix = "",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
			expr = false, -- use `expr` when creating keymaps
		}

		local visual_opts = {
			mode = "v", -- NORMAL mode
			prefix = "",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
			expr = false, -- use `expr` when creating keymaps
		}

		local normal_mappings = {
			-- bufferline
			["<leader>1"] = { ":BufferLineGoToBuffer 1<CR>", "Goto Tab1" },
			["<leader>2"] = { ":BufferLineGoToBuffer 2<CR>", "Goto Tab2" },
			["<leader>3"] = { ":BufferLineGoToBuffer 3<CR>", "Goto Tab3" },
			["<leader>4"] = { ":BufferLineGoToBuffer 4<CR>", "Goto Tab4" },
			["<leader>5"] = { ":BufferLineGoToBuffer 5<CR>", "Goto Tab5" },
			["<leader>f"] = {
				name = "+Telescope",
				b = { "<cmd>Telescope file_browser<CR>", "File Browser" },
				B = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Buffers(All)" },
				f = { "<cmd>Telescope find_files<cr>", "Find Files(Root)" },
				F = { "<cmd>Telescope find_files<cr> cwd=true", "Find Files(CWD)" },
				r = { "<cmd>Telescope oldfiles<cr>", "Open Recent Files" },
				m = { "Format File" },
				h = { "<cmd>Telescope help_tags<CR>", "Help Tags" },
				H = { "<cmd>Telescope highlights<CR>", "Highlights" },
				g = { "Grep in open files" },
				w = { "Search word in open files" },
				o = { "<cmd>Telescope smart_open<CR>", "Smart Open(Root)" },
				O = {
					"<cmd>lua require('telescope').extensions.smart_open.smart_open({cwd_only = true,})<CR>",
					"Smart Open(CWD)",
				},
				l = {
					name = "+LSP",
					r = { "<cmd>Telescope lsp_references<CR>", "References" },
					i = { "<cmd>Telescope lsp_incoming_calls<CR>", "Incoming Calls" },
					o = { "<cmd>Telescope lsp_outgoing_calls<CR>", "Outgoing Calls" },
					d = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols(Buffer)" },
					a = { "<cmd>Telescope diagnostics bufnr=0<CR>", "Diagonostics(CWD)" },
					A = { "<cmd>Telescope diagnostics<CR>", "Diagonostics(Root)" },
					w = { "<cmd>Telescope lsp_workspace_symbols<CR>", "Document Symbols(CWD)" },
					W = { "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Document Symbols(Dynamic)" },
					I = { "<cmd>Telescope lsp_implementations<CR>", "Implementation" },
					D = { "<cmd>Telescope lsp_definitions<CR>", "Definitions" },
					T = { "<cmd>Telescope lsp_type_definitions<CR>", "Type Definitions" },
				},
				s = {
					name = "+Search",
					a = { "Auto Commands" },
					b = { "Buffer(Fuzzy)" },
					c = { "Command History" },
					C = { "Commands" },
					d = { "Diagonostics" },
					g = { "Grep(CWD)" },
					G = { "Grep(Buffer)" },
					j = { "Jumplist" },
					k = { "Keymaps" },
					m = { "Jump to Marks" },
					M = { "Man Pages" },
					o = { "Vim Options" },
					q = { "QuickFix" },
					t = { "Telescope Builtins" },
					T = { "Tags" },
					s = { "Document Symbols" },
					S = { "Workspace Symbols" },
					w = { "Word(CWD)" },
					W = { "Word(Buffer)" },
				},
				R = {
					name = "+Wrapping",
					s = { "<cmd>lua require('wrapping').soft_wrap_mode()<cr>", "Soft Wrap Mode" },
					h = { "<cmd>lua require('wrapping').hard_wrap_mode()<cr>", "Hard Wrap Mode" },
					t = { "<cmd>lua require('wrapping').toggle_wrap_mode()<cr>", "Toggle Wrap Mode" },
				},
				L = { "<cmd>lua require('lint').try_lint()<cr>", "Trigger linting for current file" },
			},
			["<leader>t"] = {
				name = "+Terminal/Tab",
				f = { "Terminal Float" },
				h = { "Terminal Horizontal" },
				v = { "Terminal Vertical " },
				g = { "Lazy Git" },
				n = { "ncdu" },
				t = { "htop" },
				j = { "Goto Next Tab" },
				k = { "Goto Previous Tab" },
				p = { "Pick Tab" },
				d = { "Close Tab" },
				c = {
					name = "+close tab",
					p = { "Pick And Close Tab" },
					o = { "Close Other Tabs" },
					l = { "Close Left Tab" },
					r = { "Close Right Tab" },
				},
			},
			["<leader>s"] = {
				name = "+Window",
				h = { "<cmd>:sp<CR>", "Spilt Window Horizontal" },
				v = { "<cmd>:vsp<CR>", "Spilt Window Vertical" },
			},
			["<leader>g"] = {
				name = "+Git",
				f = { "<cmd>DiffviewFileHistory<CR>", "File History" },
				p = { "<cmd>DiffviewOpen<CR>", "Diff Project" },
				n = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
				N = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
				l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
				r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
				R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
				s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
				S = { "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", "Stage Hunk" },
				u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
				U = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
				o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
				b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
				d = {
					"<cmd>Gitsigns diffthis HEAD<cr>",
					"Diff",
				},
			},
			g = {
				d = { "<cmd>Lspsaga goto_definition<cr>", "Goto Definitions" },
				p = { "<cmd>Lspsaga peek_definition<cr>", "Peek Definitions" },
				h = { "<cmd>Lspsaga hover_doc<cr>", "Give me Hint!" },
				a = { "<cmd>Lspsaga code_action<cr>", "Code Action" },
				A = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "LSP Code Action" },
				i = { "<cmd>Lspsaga incoming_calls<cr>", "Callee Functions" },
				o = { "<cmd>Lspsaga outgoing_calls<cr>", "Called Functions" },
				r = { "<cmd>Lspsaga rename<cr>", "Rename" },
				s = { "<cmd>Lspsaga finder<cr>", "Search" },
				D = {
					name = "+Doge",
					c = { "Generate Comment" },
					t = { "Trigger Doge" },
				},
				P = {
					name = "+GotoPreview",
					d = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "Definition" },
					t = { "< <cmd>lua require('goto-preview').goto_preview_type_definition()<cr>", "Type Definition" },
					i = { "< <cmd>lua require('goto-preview').goto_preview_implementation()<cr>", "Implementation" },
					D = { "< <cmd>lua require('goto-preview').goto_preview_declaration()<cr>", "Declaration" },
					c = { "<<cmd>lua require('goto-preview').close_all_win()<cr>", "Close Windows" },
					r = { "< <cmd>lua require('goto-preview').goto_preview_references()<cr>", "References" },
				},
			},
			["<leader>a"] = {
				name = "+Diagonostics",
				b = {
					"<cmd>Lspsaga show_buf_diagnostics<cr>",
					"Show Buffer Diagonostics",
				},
				l = {
					"<cmd>Lspsaga show_line_diagnostics<cr>",
					"Show Line Diagonostics",
				},
				c = {
					"<cmd>Lspsaga show_cursor_diagnostics<cr>",
					"Show Cursor Diagonostics",
				},
				w = {
					"<cmd>Lspsaga show_workspace_diagnostics<cr>",
					"Show Workspace Diagonostics",
				},
				p = {
					"<cmd>Lspsaga diagnostic_jump_prev<cr>",
					"Previous Diagonostics",
				},
				n = {
					"<cmd>Lspsaga diagnostic_jump_next<cr>",
					"Next Diagonostics",
				},
			},
			["<leader>d"] = {
				name = "+Dap",
				B = { "BreakPoint Condition" },
				b = { "Toggle BreakPoint" },
				c = { "Continue " },
				C = { "Run to Cursor" },
				a = { "Run with Args" },
				l = { "Run Last" },
				g = { "Goto line (on execute)" },
				p = { "Pause" },
				s = { "Session " },
				r = { "Toggle REPL" },
				o = { "Step Out" },
				O = { "Step Over" },
				i = { "Step Into" },
				j = { "Down" },
				k = { "Up" },
				w = { "Widgets" },
				u = { "Dap UI" },
				e = { "Dap Eval " },
			},
			["<leader>v"] = {
				name = "+Neotest",
				a = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach Nearest" },
				d = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug Nearest" },
				t = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run File" },
				T = { "<cmd>lua require('neotest').run.run(vim.uv.cwd())<cr>", "Run All Test Files" },
				r = { "<cmd>lua require('neotest').run.run()<cr>", "Run Nearest" },
				l = { "<cmd>lua require('neotest').run.run_last()<cr>", "Run Last" },
				s = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Toggle Summary" },
				o = {
					"<cmd>lua require('neotest').output.open({ enter = true, auto_close = true })<cr>",
					"Show Output",
				},
				O = { "<cmd>lua require('neotest').output_panel.toggle()<cr>", "Toggle Output Panel" },
				S = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
			},
			--[[ ["<leader>n"] = {
                name = "+REPL",
                s = {"<cmd>lua require('nvim-python-repl').send_statement_definition()<cr>", "Send semantic unit to REPL" },
                b = {"<cmd>lua require('nvim-python-repl').send_buffer_to_repl()<cr>", "Send entire buffer to REPL" },
                e = {"<cmd>lua require('nvim-python-repl').toggle_execute()<cr>", "Execute command in REPL after sent" },
                t = {"<cmd>lua require('nvim-python-repl').toggle_vertical()<cr>", "Create REPL in vertical or horizontal split" },
                o = {"<cmd>lua require('nvim-python-repl').open_repl()<cr>", "Opens the REPL in a window split" },
            }, ]]
			["<leader>k"] = {
				name = "+LSP",
				t = { "Toggle Signature" },
				h = { "Hover LSP Info" },
				q = { "Quit LSP Floating Windows" },
			},
			["<leader>m"] = {
				name = "+CscopeMaps",
				s = { "Find all references" },
				g = { "Find global definition(s)" },
				c = { "Find all calls to the function name" },
				t = { "Find all instances of the text" },
				e = { "egrep search for the word" },
				f = { "Open the filename" },
				i = { "Find files that include the filename" },
				d = { "Find functions that function calls" },
				a = { "Find places where symbol assigned a value" },
				b = { "Build cscope database" },
				-- Ctrl-]	do :Cstag <cword>
			},
			["<leader>c"] = {
				name = "+Crates",
				t = { "<cmd>lua require('crates').toggle()<cr>", "Toggle" },
				r = { "<cmd>lua require('crates').reload()<cr>", "Reload" },
				v = { "<cmd>lua require('crates').show_versions_popup()<cr>", "Show versions" },
				f = { "<cmd>lua require('crates').show_features_popup()<cr>", "Show features" },
				d = { "<cmd>lua require('crates').show_dependencies_popup<cr>", "Show dependencies" },
				u = { "<cmd>lua require('crates').update_crate()<cr>", "Update create" },
				a = { "<cmd>lua require('crates').update_all_crates<cr>", "Update all crates" },
				U = { "<cmd>lua require('crates').upgrade_crate()<cr>", "Upgrade create" },
				A = { "<cmd>lua require('crates').upgrade_all_crates()<cr>", "Upgrade all crates" },
				x = {
					"<cmd>lua require('crates').expand_plain_crate_to_inline_table()<cr>",
					"Expand plain create to inline table",
				},
				X = { "<cmd>lua require('crates').extract_crate_into_table()<cr>", "Extract create into table" },
				H = { "<cmd>lua require('crates').open_homepage()<cr>", "Open homepage" },
				R = { "<cmd>lua require('crates').open_repository()<cr>", "Open repository" },
				D = { "<cmd>lua require('crates').open_documentation()<cr>", "Open documentation" },
				C = { "<cmd>lua require('crates').open_crates_io()<cr>", "Open crates io" },
			},
			["<leader>r"] = {
				name = "+Rust",
				D = { "<cmd>RustLsp debuggables<cr>", "Rust Debuggables" },
				R = { "<cmd>RustLsp runnables<cr>", "Rust Runnables" },
				T = { "<cmd>RustLsp testables<cr>", "Rust Testables" },
				e = { "<cmd>RustLsp expandMacro<cr>", "Expand Macro" },
				b = { "<cmd>RustLsp rebuildProcMacros<cr>", "Rebuild ProcMacros" },
				u = { "<cmd>RustLsp moveItem up<cr>", "Move item up" },
				d = { "<cmd>RustLsp moveItem down<cr>", "Move item down" },
				a = { "<cmd>RustLsp codeAction<cr>", "Code Action" },
				h = { "<cmd>RustLsp hover actions<cr>", "Hover Actions" },
				n = { "<cmd>RustLsp hover range<cr>", "Hover Range" },
				E = { "<cmd>RustLsp explainError<cr>", "Explain Error" },
				r = { "<cmd>RustLsp renderDiagnostic<cr>", "Render Diagnostic" },
				o = { "<cmd>RustLsp openCargo<cr>", "Open cargo" },
				O = { "<cmd>RustLsp openDocs<cr>", "Open docs.rs documentation" },
				p = { "<cmd>RustLsp parentModule<cr>", "Rust parent module" },
				s = {
					name = "+WorkspaceSymbol",
					t = { "<cmd>RustLsp workspaceSymbol onlyTypes<cr>", "Only type symbols" },
					a = { "<cmd>RustLsp workspaceSymbol allSymbols<cr>", "Show all symbols" },
				},
				j = { "<cmd>RustLsp joinLines<cr>", "Join lines" },
				S = { "<cmd>RustLsp ssr<cr>", "Structural search Replace" },
				g = { "<cmd>RustLsp crateGraph<cr>", "View create graph" },
				t = { "<cmd>RustLsp syntaxTree<cr>", "Rust syntax tree" },
				f = {
					name = "+FlyCheck",
				    r =	{ "<cmd>RustLsp flyCheck run<cr>", "Run check" },
				    c =	{ "<cmd>RustLsp flyCheck clear<cr>", "Clear check" },
				    n =	{ "<cmd>RustLsp flyCheck cancel<cr>", "Cancel check" },
				},
				v = { "<cmd>RustLsp view hir<cr>", "View rust HIR" },
				V = { "<cmd>RustLsp vim mir<cr>", "View rust MIR" },
			},
		}

		local visual_mappings = {
			--[[ name = "+REPL",
			s = { "<cmd>lua require('nvim-python-repl').send_visual_to_repl()<cr>", "Send visual selection to REPL" }, ]]
			["<leader>c"] = {
				name = "+Crates",
				u = { "<cmd>lua require('crates').update_crates()", "Update crates" },
				U = { "<cmd>lua require('crates').upgrade_crates()", "Upgrade crates" },
			},
		}

		which_key.setup(setup)
		which_key.register(normal_mappings, normal_opts)
		which_key.register(visual_mappings, visual_opts)
	end,
}
