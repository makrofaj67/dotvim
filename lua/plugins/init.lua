_G.dd = function(...)
	Snacks.debug.inspect(...)
end
_G.bt = function()
	Snacks.debug.backtrace()
end
vim.print = _G.dd

return {
	require("plugins.snacks"),
	require("plugins.mini"),
	require("plugins.nvchadcolors"),
	require("plugins.conform"),
	require("plugins.neaterm"),
	require("plugins.treesitter"),
	require("plugins.cmp"),
	require("plugins.lsp"),
	require("plugins.lint"),
	require("plugins.debugger"),
	require("plugins.modicator"),
	require("plugins.lualine"),
	require("plugins.gitsigns"),
	require("plugins.indent_blankline"),
	require("plugins.42"),
	require("plugins.neo-tree"),
	require("plugins.menu"),
	-- require("plugins.copilot"),
	-- require("plugins.precognition"),
	-- require("plugins.hardtime"),
	-- require("plugins.avante"),
	require("plugins.barbar"),
}
