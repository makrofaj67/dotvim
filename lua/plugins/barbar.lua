return {
	"romgrk/barbar.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"moll/vim-bbye",
	},
	version = "^1.0.0", -- Specify a version to avoid potential breaking changes
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	config = function()
		local colors = {
			bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg or 0,
			fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg or 0,
			bg_dark = vim.api.nvim_get_hl(0, { name = "NormalFloat" }).bg or 0,
			fg_dark = vim.api.nvim_get_hl(0, { name = "Comment" }).fg or 0,
			fg_bright = vim.api.nvim_get_hl(0, { name = "Special" }).fg or 0,
			yellow = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg or 0,
			red = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg or 0,
			accent = vim.api.nvim_get_hl(0, { name = "Function" }).fg or 0,
		}

		require("barbar").setup({
			-- Your existing configuration
			animation = true,
			auto_hide = false,
			tabpages = true,
			clickable = true,

			exclude_ft = {
				"snacks_layout_box",
				"snack_picker_input",
				"neo-tree",
				"Trouble",
			},

			icons = {
				buffer_index = true,
				buffer_number = false,
				button = "󰅖",
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
			},

			sidebar_filetypes = {
				snacks_layout_box = { text = "blλack mesa", align = "center" },
				["neo-tree"] = { text = "Neo-Tree" },
			},
		})

		-- Safe color setting with fallback
		local function safe_set_hl(name, opts)
			pcall(vim.api.nvim_set_hl, 0, name, opts)
		end

		safe_set_hl("BufferCurrent", { fg = colors.fg_bright, bg = colors.bg, bold = true })
		safe_set_hl("BufferCurrentMod", { fg = colors.yellow, bg = colors.bg, bold = true })
		safe_set_hl("BufferCurrentSign", { fg = colors.accent, bg = colors.bg })

		safe_set_hl("BufferInactive", { fg = colors.fg_dark, bg = colors.bg_dark })
		safe_set_hl("BufferInactiveMod", { fg = colors.yellow, bg = colors.bg_dark })

		safe_set_hl("BufferTabpageFill", { fg = colors.fg, bg = colors.bg_dark })

		-- Keymaps
		local map = vim.api.nvim_set_keymap
		local opts = { noremap = true, silent = true }

		-- Your existing keymaps...
		map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
		map("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)
		-- ... (rest of your keymaps)

		-- Autocommands
		vim.api.nvim_create_augroup("BarbarConfig", { clear = true })

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = "BarbarConfig",
			callback = function()
				-- Reload colors
				require("barbar").setup({})
			end,
		})
	end,
}
