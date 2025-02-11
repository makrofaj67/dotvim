-- Set script encoding
vim.opt.encoding = "utf-8"

-- Global configuration
vim.g.smart_escape_timeout = 200 -- milliseconds
vim.g.smart_escape_enabled = true
vim.g.smart_escape_visual_feedback = true

local M = {}

-- Helper function to get previous character
local function get_prev_char()
	local col = vim.fn.col(".")
	local line = vim.fn.getline(".")

	if col <= 1 or line == "" then
		return ""
	end

	-- Get the character before cursor
	return vim.fn.strcharpart(line, vim.fn.strchars(line:sub(1, col - 1)) - 1, 1)
end

-- Smart escape function
local function smart_escape()
	local prev_char = get_prev_char()

	if prev_char == "j" then
		return "<BS><Esc>"
	end

	return "k"
end

-- Smart j function
local function smart_j()
	local win = vim.api.nvim_get_current_win()
	local now = vim.loop.now()

	-- Store timestamp in window variables
	vim.w[win].last_j_time = now

	-- Clear existing timer if any
	if vim.w[win].smart_j_timer then
		vim.loop.timer_stop(vim.w[win].smart_j_timer)
	end

	-- Set cleanup timer
	vim.defer_fn(function()
		vim.w[win].smart_j_timer = nil
		vim.w[win].last_j_time = nil
	end, vim.g.smart_escape_timeout)

	return "j"
end

-- Visual feedback functions
local function remove_highlight()
	local win = vim.api.nvim_get_current_win()
	if vim.w[win].smart_escape_highlight then
		vim.fn.matchdelete(vim.w[win].smart_escape_highlight)
		vim.w[win].smart_escape_highlight = nil
	end
end

local function visual_feedback()
	if vim.v.char == "j" then
		local win = vim.api.nvim_get_current_win()
		if not vim.w[win].smart_escape_highlight then
			vim.w[win].smart_escape_highlight = vim.fn.matchadd("IncSearch", "\\%#", 100)
			vim.defer_fn(remove_highlight, vim.g.smart_escape_timeout)
		end
	end
end

-- Toggle functions
function M.toggle_smart_escape()
	vim.g.smart_escape_enabled = not vim.g.smart_escape_enabled
	print("Smart Escape " .. (vim.g.smart_escape_enabled and "enabled" or "disabled"))
end

function M.toggle_visual_feedback()
	vim.g.smart_escape_visual_feedback = not vim.g.smart_escape_visual_feedback
	print("Visual Feedback " .. (vim.g.smart_escape_visual_feedback and "enabled" or "disabled"))
end

-- Set up mappings and autocommands
local function setup()
	-- Map keys
	vim.keymap.set("i", "k", smart_escape, { expr = true })
	vim.keymap.set("i", "j", smart_j, { expr = true })

	-- Create autocommands
	local group = vim.api.nvim_create_augroup("SmartEscape", { clear = true })
	vim.api.nvim_create_autocmd("InsertCharPre", {
		group = group,
		callback = function()
			if vim.g.smart_escape_visual_feedback then
				visual_feedback()
			end
		end,
	})

	-- Create user commands
	vim.api.nvim_create_user_command("SmartEscapeToggle", M.toggle_smart_escape, {})
	vim.api.nvim_create_user_command("SmartEscapeVisualFeedbackToggle", M.toggle_visual_feedback, {})
end

-- Initialize
setup()

return M
