return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.ai").setup( -- No need to copy this inside `setup()`. Will be used automatically.
			{
				-- Table with textobject id as fields, textobject specification as values.
				-- Also use this to disable builtin textobjects. See |MiniAi.config|.
				custom_textobjects = nil,

				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					-- Main textobject prefixes
					around = "a",
					inside = "i",

					-- Next/last variants
					around_next = "an",
					inside_next = "in",
					around_last = "al",
					inside_last = "il",

					-- Move cursor to corresponding edge of `a` textobject
					goto_left = "g[",
					goto_right = "g]",
				},

				-- Number of lines within which textobject is searched
				n_lines = 50,

				-- How to search for object (first inside current line, then inside
				-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
				-- 'cover_or_nearest', 'next', 'previous', 'nearest'.
				search_method = "cover_or_next",

				-- Whether to disable showing non-error feedback
				-- This also affects (purely informational) helper messages shown after
				-- idle time if user input is required.
				silent = false,
			}
		)
		-- require('mini.completion').setup(
		-- -- No need to copy this inside `setup()`. Will be used automatically.
		-- 	{
		-- 		-- Delay (debounce type, in ms) between certain Neovim event and action.
		-- 		-- This can be used to (virtually) disable certain automatic actions by
		-- 		-- setting very high delay time (like 10^7).
		-- 		delay = { completion = 100, info = 100, signature = 50 },
		--
		-- 		-- Configuration for action windows:
		-- 		-- - `height` and `width` are maximum dimensions.
		-- 		-- - `border` defines border (as in `nvim_open_win()`).
		-- 		window = {
		-- 			info = { height = 25, width = 80, border = 'none' },
		-- 			signature = { height = 25, width = 80, border = 'none' },
		-- 		},
		--
		-- 		-- Way of how module does LSP completion
		-- 		lsp_completion = {
		-- 			-- `source_func` should be one of 'completefunc' or 'omnifunc'.
		-- 			source_func = 'completefunc',
		--
		-- 			-- `auto_setup` should be boolean indicating if LSP completion is set up
		-- 			-- on every `BufEnter` event.
		-- 			auto_setup = true,
		--
		-- 			-- A function which takes LSP 'textDocument/completion' response items
		-- 			-- and word to complete. Output should be a table of the same nature as
		-- 			-- input items. Common use case is custom filter/sort.
		-- 			--  process_items = --<function: MiniCompletion.default_process_items>,
		-- 		},
		--
		-- 		-- Fallback action. It will always be run in Insert mode. To use Neovim's
		-- 		-- built-in completion (see `:h ins-completion`), supply its mapping as
		-- 		-- string. Example: to use 'whole lines' completion, supply '<C-x><C-l>'.
		-- 		--fallback_action = --<function: like `<C-n>` completion>,
		--
		-- 		-- Module mappings. Use `''` (empty string) to disable one. Some of them
		-- 		-- might conflict with system mappings.
		-- 		mappings = {
		-- 			force_twostep = '<C-Space>', -- Force two-step completion
		-- 			force_fallback = '<A-Space>', -- Force fallback completion
		-- 		},
		--
		-- 		-- Whether to set Vim's settings for better experience (modifies
		-- 		-- `shortmess` and `completeopt`)
		-- 		set_vim_settings = true,
		-- 	})
		require("mini.move").setup( -- No need to copy this inside `setup()`. Will be used automatically.
			{
				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
					left = "<M-h>",
					right = "<M-l>",
					down = "<M-j>",
					up = "<M-k>",

					-- Move current line in Normal mode
					line_left = "<M-h>",
					line_right = "<M-l>",
					line_down = "<M-j>",
					line_up = "<M-k>",
				},

				-- Options which control moving behavior
				options = {
					-- Automatically reindent selection during linewise vertical move
					reindent_linewise = true,
				},
			}
		)
		require("mini.pairs").setup( -- No need to copy this inside `setup()`. Will be used automatically.
			{
				-- In which modes mappings from this `config` should be created
				modes = { insert = true, command = false, terminal = false },

				-- Global mappings. Each right hand side should be a pair information, a
				-- table with at least these fields (see more in |MiniPairs.map|):
				-- - <action> - one of 'open', 'close', 'closeopen'.
				-- - <pair> - two character string for pair to be used.
				-- By default pair is not inserted after `\`, quotes are not recognized by
				-- `<CR>`, `'` does not insert pair after a letter.
				-- Only parts of tables can be tweaked (others will use these defaults).
				mappings = {
					["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
					["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
					["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

					[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
					["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
					["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

					['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
					["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
					["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
				},
			}
		)
		require("mini.surround").setup( -- No need to copy this inside `setup()`. Will be used automatically.
			{
				-- Add custom surroundings to be used on top of builtin ones. For more
				-- information with examples, see `:h MiniSurround.config`.
				custom_surroundings = nil,

				-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
				highlight_duration = 500,

				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					add = "sa", -- Add surrounding in Normal and Visual modes
					delete = "sd", -- Delete surrounding
					find = "sf", -- Find surrounding (to the right)
					find_left = "sF", -- Find surrounding (to the left)
					highlight = "sh", -- Highlight surrounding
					replace = "sr", -- Replace surrounding
					update_n_lines = "sn", -- Update `n_lines`

					suffix_last = "l", -- Suffix to search with "prev" method
					suffix_next = "n", -- Suffix to search with "next" method
				},

				-- Number of lines within which surrounding is searched
				n_lines = 20,

				-- Whether to respect selection type:
				-- - Place surroundings on separate lines in linewise mode.
				-- - Place surroundings on each line in blockwise mode.
				respect_selection_type = false,

				-- How to search for surrounding (first inside current line, then inside
				-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
				-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
				-- see `:h MiniSurround.config`.
				search_method = "cover",

				-- Whether to disable showing non-error feedback
				-- This also affects (purely informational) helper messages shown after
				-- idle time if user input is required.
				silent = false,
			}
		)
		require("mini.clue").setup({
			triggers = {
				-- Leader triggers
				{ mode = "n", keys = "<Leader>" },
				{ mode = "x", keys = "<Leader>" },

				-- Built-in completion
				{ mode = "i", keys = "<C-x>" },

				-- `g` key
				{ mode = "n", keys = "g" },
				{ mode = "x", keys = "g" },

				-- Marks
				{ mode = "n", keys = "'" },
				{ mode = "n", keys = "`" },
				{ mode = "x", keys = "'" },
				{ mode = "x", keys = "`" },

				-- Registers
				{ mode = "n", keys = '"' },
				{ mode = "x", keys = '"' },
				{ mode = "i", keys = "<C-r>" },
				{ mode = "c", keys = "<C-r>" },

				-- Window commands
				{ mode = "n", keys = "<C-w>" },

				-- `z` key
				{ mode = "n", keys = "z" },
				{ mode = "x", keys = "z" },
			},

			clues = {
				-- Enhance this by adding descriptions for <Leader> mapping groups
				require("mini.clue").gen_clues.builtin_completion(),
				require("mini.clue").gen_clues.g(),
				require("mini.clue").gen_clues.marks(),
				require("mini.clue").gen_clues.registers(),
				require("mini.clue").gen_clues.windows(),
				require("mini.clue").gen_clues.z(),
			},
		})
		require("mini.misc").setup({
			make_global = { "setup_restore_cursor" },
		})
		require("mini.visits").setup( -- No need to copy this inside `setup()`. Will be used automatically.
			{
				-- How visit index is converted to list of paths
				list = {
					-- Predicate for which paths to include (all by default)
					filter = nil,

					-- Sort paths based on the visit data (robust frecency by default)
					sort = nil,
				},

				-- Whether to disable showing non-error feedback
				silent = false,

				-- How visit index is stored
				store = {
					-- Whether to write all visits before Neovim is closed
					autowrite = true,

					-- Function to ensure that written index is relevant
					normalize = nil,

					-- Path to store visit index
					path = vim.fn.stdpath("data") .. "/mini-visits-index",
				},

				-- How visit tracking is done
				track = {
					-- Start visit register timer at this event
					-- Supply empty string (`''`) to not do this automatically
					event = "BufEnter",

					-- Debounce delay after event to register a visit
					delay = 1000,
				},
			}
		)
	end,
}
