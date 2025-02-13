return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.ai").setup({

			custom_textobjects = nil,

			mappings = {

				around = "a",
				inside = "i",

				around_next = "an",
				inside_next = "in",
				around_last = "al",
				inside_last = "il",

				goto_left = "g[",
				goto_right = "g]",
			},

			n_lines = 50,

			search_method = "cover_or_next",

			silent = false,
		})

		require("mini.move").setup({

			mappings = {

				left = "<M-h>",
				right = "<M-l>",
				down = "<M-j>",
				up = "<M-k>",

				line_left = "<M-h>",
				line_right = "<M-l>",
				line_down = "<M-j>",
				line_up = "<M-k>",
			},

			options = {

				reindent_linewise = true,
			},
		})
		require("mini.pairs").setup({

			modes = { insert = true, command = false, terminal = false },

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
		})
		require("mini.surround").setup({

			custom_surroundings = nil,

			highlight_duration = 500,

			mappings = {
				add = "sa",
				delete = "sd",
				find = "sf",
				find_left = "sF",
				highlight = "sh",
				replace = "sr",
				update_n_lines = "sn",

				suffix_last = "l",
				suffix_next = "n",
			},

			n_lines = 20,

			respect_selection_type = false,

			search_method = "cover",

			silent = false,
		})
		require("mini.clue").setup({
			triggers = {

				{ mode = "n", keys = "<Leader>" },
				{ mode = "x", keys = "<Leader>" },

				{ mode = "i", keys = "<C-x>" },

				{ mode = "n", keys = "g" },
				{ mode = "x", keys = "g" },

				{ mode = "n", keys = "'" },
				{ mode = "n", keys = "`" },
				{ mode = "x", keys = "'" },
				{ mode = "x", keys = "`" },

				{ mode = "n", keys = '"' },
				{ mode = "x", keys = '"' },
				{ mode = "i", keys = "<C-r>" },
				{ mode = "c", keys = "<C-r>" },

				{ mode = "n", keys = "<C-w>" },

				{ mode = "n", keys = "z" },
				{ mode = "x", keys = "z" },
			},

			clues = {

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
		require("mini.visits").setup({

			list = {

				filter = nil,

				sort = nil,
			},

			silent = false,

			store = {

				autowrite = true,

				normalize = nil,

				path = vim.fn.stdpath("data") .. "/mini-visits-index",
			},

			track = {

				event = "BufEnter",

				delay = 1000,
			},
		})
	end,
}
