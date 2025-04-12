return {
	{
		{ "nvzone/volt", lazy = true },
		{ "nvzone/menu", lazy = true },
		config = function()
			require("menu").open(options, opts)
			-- Keyboard users
		end,
	},
}
