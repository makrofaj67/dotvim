local M = {}

M.setup = function()
	-- Load other options/configurations
	require("core.keymaps")

	-- Set a default colorscheme in case nothing else works
	vim.cmd([[
    if !exists('g:colors_name')
        colorscheme default
        endif
]])

	-- Load the saved theme
	require("core.utils").load_saved_theme()
end

return M
