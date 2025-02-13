return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = "*",
	opts = {

		provider = "gemini",
		gemini = {
			model = "gemini-2.0-flash",
		},
		file_selector = {
			provider = "snacks",
		},
		hints = {
			enabled = false,
		},
	},

	build = "make",

	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",

		"folke/snacks.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-tree/nvim-web-devicons",

		{

			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {

				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},

					use_absolute_path = true,
				},
			},
		},
		{

			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
