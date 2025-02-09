-- lua/options/config.lua
local M = {}

-- Path to store the configuration
M.config_file = vim.fn.stdpath("data") .. "/theme_config.lua"

-- Function to save configuration
M.save_config = function(config)
	local file = io.open(M.config_file, "w")
	if file then
		local serialized = "return " .. vim.inspect(config)
		file:write(serialized)
		file:close()
	end
end

-- Function to load configuration
M.load_config = function()
	local status_ok, config = pcall(dofile, M.config_file)
	if status_ok then
		return config
	end
	return {}
end

return M
