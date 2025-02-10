return {
	{
		"42Paris/42header",
		cmd = { "Stdheader" },
	},
	{
		"MrSloth-dev/42-NorminetteNvim",
		dependencies = { "nvim-lua/plenary.nvim", "echasnovski/mini.icons" },
		lazy = false,
		config = function()
			require("norminette").setup({
				--	norm_keybind = "<leader>n",
				--	size_keybind = "<leader>ns",
				diagnost_color = "#00ff00",
				show_size = true,
			})
		end,
	},
}
