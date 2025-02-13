return {
	"mawkler/modicator.nvim",
	init = function()
		vim.o.cursorline = true
		vim.o.number = true
		vim.o.termguicolors = true
	end,
	opts = {
		show_warnings = false,
		highlights = {

			defaults = {
				bold = false,
				italic = false,
			},

			use_cursorline_background = false,
		},
		integration = {
			lualine = {
				enabled = true,

				mode_section = nil,

				highlight = "bg",
			},
		},
	},
}
