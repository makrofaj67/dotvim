-- lua/plugins/telescope.lua
return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5", -- Replace with the latest version
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "smart" },
				file_ignore_patterns = {
					".git/",
					"node_modules",
					"target",
					"dist",
					".cache",
				},
				mappings = {
					i = {
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-c>"] = actions.close,
						["<Down>"] = actions.move_selection_next,
						["<Up>"] = actions.move_selection_previous,
						["<CR>"] = actions.select_default,
						["<C-x>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<PageUp>"] = actions.results_scrolling_up,
						["<PageDown>"] = actions.results_scrolling_down,
						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-l>"] = actions.complete_tag,
						["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
					},
					n = {
						["<esc>"] = actions.close,
						["<CR>"] = actions.select_default,
						["<C-x>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,
						["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
						["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["j"] = actions.move_selection_next,
						["k"] = actions.move_selection_previous,
						["H"] = actions.move_to_top,
						["M"] = actions.move_to_middle,
						["L"] = actions.move_to_bottom,
						["<Down>"] = actions.move_selection_next,
						["<Up>"] = actions.move_selection_previous,
						["gg"] = actions.move_to_top,
						["G"] = actions.move_to_bottom,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<PageUp>"] = actions.results_scrolling_up,
						["<PageDown>"] = actions.results_scrolling_down,
						["?"] = actions.which_key,
					},
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					--@usage don't include the filename in the search results
					only_sort_text = true,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		-- Load extensions
		telescope.load_extension("fzf")

		-- Keymaps
		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true }

		-- Find files
		keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
		-- Find text
		keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
		-- Find buffers
		keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
		-- Find help
		keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)
		-- Find recent files
		keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", opts)
		-- Find marks
		keymap("n", "<leader>fm", "<cmd>Telescope marks<CR>", opts)
		-- Find keymaps
		keymap("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", opts)
		-- Find in current buffer
		keymap("n", "<leader>fc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
		-- Browse git files
		keymap("n", "<leader>gf", "<cmd>Telescope git_files<CR>", opts)
		-- Browse git commits
		keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", opts)
		-- Browse git branches
		keymap("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", opts)
		-- Browse git status
		keymap("n", "<leader>gs", "<cmd>Telescope git_status<CR>", opts)
		-- Theme picker
		keymap("n", "<leader>th", function()
			require("core.init").telescope_theme_switcher()
		end, { desc = "Select Theme" })
	end,
}
