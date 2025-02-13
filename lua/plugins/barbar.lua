-- return {
-- 	"romgrk/barbar.nvim",
-- 	dependencies = {
-- 		"nvim-tree/nvim-web-devicons",
-- 		"moll/vim-bbye",
-- 	},
-- 	version = "^1.0.0", -- Specify a version to avoid potential breaking changes
-- 	init = function()
-- 		vim.g.barbar_auto_setup = false
-- 	end,
-- 	config = function()
-- 		local colors = {}
--
-- 		local function set_colors()
-- 			colors.bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg or 0
-- 			colors.fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg or 0
-- 			colors.bg_dark = vim.api.nvim_get_hl(0, { name = "NormalFloat" }).bg or 0
-- 			-- colors.fg_dark = vim.api.nvim_get_hl(0, { name = "Comment" }).fg or 0
-- 			colors.fg_bright = vim.api.nvim_get_hl(0, { name = "Special" }).fg or 0
-- 			colors.yellow = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg or 0
-- 			colors.red = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg or 0
-- 			colors.accent = vim.api.nvim_get_hl(0, { name = "Function" }).fg or 0
-- 			colors.fg_dark = "#a0a0a0"
-- 		end
--
-- 		set_colors()
--
-- 		require("barbar").setup({
-- 			-- Your existing configuration
-- 			animation = true,
-- 			auto_hide = false,
-- 			tabpages = true,
-- 			clickable = true,
--
-- 			exclude_ft = {
-- 				"snacks_layout_box",
-- 				"snack_picker_input",
-- 				"neo-tree",
-- 				"Trouble",
-- 			},
--
-- 			icons = {
-- 				buffer_index = false,
-- 				buffer_number = false,
-- 				button = "λ",
-- 				preset = "slanted",
-- 				diagnostics = {
-- 					[vim.diagnostic.severity.ERROR] = { enabled = false },
-- 					[vim.diagnostic.severity.WARN] = { enabled = false },
-- 					[vim.diagnostic.severity.INFO] = { enabled = false },
-- 					[vim.diagnostic.severity.HINT] = { enabled = false },
-- 				},
-- 				gitsigns = {
-- 					added = { enabled = false },
-- 					changed = { enabled = false },
-- 					deleted = { enabled = false },
-- 				},
-- 				filetype = {
-- 					custom_colors = false,
-- 					enabled = true,
-- 				},
-- 				separator = { left = "|", right = "" },
--
-- 				-- If true, add an additional separator at the end of the buffer list
-- 				separator_at_end = true,
-- 			},
--
-- 			sidebar_filetypes = {
-- 				snacks_layout_box = { text = "blλack mesa", align = "center" },
-- 				["neo-tree"] = { text = "Neo-Tree" },
-- 			},
-- 		})
--
-- 		-- Safe color setting with fallback
-- 		local function safe_set_hl(name, opts)
-- 			pcall(vim.api.nvim_set_hl, 0, name, opts)
-- 		end
--
-- 		safe_set_hl("BufferCurrent", { fg = colors.fg_bright, bg = colors.bg, bold = true })
-- 		safe_set_hl("BufferCurrentMod", { fg = colors.yellow, bg = colors.bg, bold = true })
-- 		safe_set_hl("BufferCurrentSign", { fg = colors.accent, bg = colors.bg })
--
-- 		safe_set_hl("BufferInactive", { fg = colors.fg_dark, bg = colors.bg_dark })
-- 		safe_set_hl("BufferInactiveMod", { fg = colors.yellow, bg = colors.bg_dark })
--
-- 		safe_set_hl("BufferTabpageFill", { fg = colors.fg, bg = colors.bg_dark })
--
-- 		-- Keymaps
-- 		local map = vim.api.nvim_set_keymap
-- 		local opts = { noremap = true, silent = true }
--
-- 		-- Your existing keymaps...
-- 		map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
-- 		map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)
-- 		-- ... (rest of your keymaps)
--
-- 		-- Autocommands
-- 		vim.api.nvim_create_augroup("BarbarConfig", { clear = true })
--
-- 		vim.api.nvim_create_autocmd("ColorScheme", {
-- 			group = "BarbarConfig",
-- 			callback = function()
-- 				set_colors()
-- 				require("barbar").setup({})
-- 			end,
-- 		})
-- 	end,
-- }
return {
	"romgrk/barbar.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"moll/vim-bbye",
	},
	version = "^1.0.0",
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	config = function()
		local colors = {}
		local function set_colors()
			colors.bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg or 0
			colors.fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg or 0
			colors.bg_dark = vim.api.nvim_get_hl(0, { name = "NormalFloat" }).bg or 0
			colors.fg_bright = vim.api.nvim_get_hl(0, { name = "Special" }).fg or 0
			colors.yellow = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg or 0
			colors.red = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg or 0
			colors.accent = vim.api.nvim_get_hl(0, { name = "Function" }).fg or 0
			colors.fg_dark = "#c0c0c0"
		end
		set_colors()

		require("barbar").setup({
			animation = true,
			auto_hide = false,
			tabpages = true,
			clickable = true,
			exclude_ft = {
				"neo-tree",
				"Trouble",
			},
			icons = {
				buffer_index = false,
				buffer_number = false,
				button = "λ",
				preset = "slanted",
				diagnostics = {
					[vim.diagnostic.severity.ERROR] = { enabled = false },
					[vim.diagnostic.severity.WARN] = { enabled = false },
					[vim.diagnostic.severity.INFO] = { enabled = false },
					[vim.diagnostic.severity.HINT] = { enabled = false },
				},
				gitsigns = {
					added = { enabled = false },
					changed = { enabled = false },
					deleted = { enabled = false },
				},
				filetype = {
					custom_colors = false,
					enabled = true,
				},
				separator = { left = "|", right = "" },
				separator_at_end = true,
			},
			sidebar_filetypes = {
				["snacks_layout_box"] = {
					text = "blλack mesa",
					event = "BufWinEnter",
					align = "center",
				},
				["snacks.explorer"] = {
					text = "snacks.explorer",
					event = "BufWinEnter",
					align = "center",
				},
				["neo-tree"] = { text = "Neo-Tree" },
				["nterm"] = { -- Add specific handling for nterm
					text = "Terminal",
					event = "BufWinEnter",
				},
			},
			focus_on_close = "previous",
			hide = { inactive = false },
			highlight_visible = true, -- Add this to ensure visible buffers are highlighted correctly
			highlight_alternate = false, -- Disable alternate highlighting
			highlight_inactive_file_icons = false,
			no_name_title = "New Buffer",
		})

		-- Modified highlight groups with better visible state handling
		local function safe_set_hl(name, opts)
			pcall(vim.api.nvim_set_hl, 0, name, opts)
		end

		-- Set all highlight groups explicitly
		safe_set_hl("BufferCurrent", { fg = colors.fg_bright, bg = colors.bg, bold = true })
		safe_set_hl("BufferCurrentMod", { fg = colors.yellow, bg = colors.bg, bold = true })
		safe_set_hl("BufferCurrentSign", { fg = colors.accent, bg = colors.bg })
		safe_set_hl("BufferCurrentIcon", { fg = colors.fg_bright, bg = colors.bg })

		safe_set_hl("BufferVisible", { fg = colors.fg_dark, bg = colors.bg_dark })
		safe_set_hl("BufferVisibleMod", { fg = colors.yellow, bg = colors.bg_dark })
		safe_set_hl("BufferVisibleSign", { fg = colors.fg_dark, bg = colors.bg_dark })
		safe_set_hl("BufferVisibleIcon", { fg = colors.fg_dark, bg = colors.bg_dark })

		safe_set_hl("BufferInactive", { fg = colors.fg_dark, bg = colors.bg_dark })
		safe_set_hl("BufferInactiveMod", { fg = colors.yellow, bg = colors.bg_dark })
		safe_set_hl("BufferInactiveSign", { fg = colors.fg_dark, bg = colors.bg_dark })
		safe_set_hl("BufferInactiveIcon", { fg = colors.fg_dark, bg = colors.bg_dark })

		safe_set_hl("BufferTabpageFill", { fg = colors.fg, bg = colors.bg_dark })
		safe_set_hl("BufferTabpagesSep", { fg = colors.fg_dark, bg = colors.bg_dark })

		-- Your keymaps
		local map = vim.api.nvim_set_keymap
		local opts = { noremap = true, silent = true }
		map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
		map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)

		-- Add autocommands to handle terminal and special buffer focus
		vim.api.nvim_create_augroup("BarbarConfig", { clear = true })

		-- Handle ColorScheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = "BarbarConfig",
			callback = function()
				set_colors()
				require("barbar").setup({})
			end,
		})

		-- Handle buffer visibility
		vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
			group = "BarbarConfig",
			callback = function()
				-- Force refresh of buffer appearance
				vim.cmd("redrawtabline")
			end,
		})
	end,
}
