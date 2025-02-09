-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	-- NOTE: Yes, you can install new plugins here!
	"mfussenegger/nvim-dap",
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",

		-- Required dependency for nvim-dap-ui
		"nvim-neotest/nvim-nio",

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- Add your own debuggers here
		"leoluz/nvim-dap-go",
	},
	keys = {
		-- Basic debugging keymaps, feel free to change to your liking!
		{
			"<F1>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},

		{
			"<F5>",
			function()
				local file_path = vim.fn.expand("%:p")
				local input = vim.fn.input("Run with args (file_path args): ", file_path .. " ")
				local parts = vim.split(input, " ", { trimempty = true })

				-- Extract file path and arguments
				local target_file = parts[1]
				table.remove(parts, 1)
				local args = parts

				local dap = require("dap")

				-- Configure based on filetype
				if vim.bo.filetype == "c" then
					-- Create output binary path
					local output_path = vim.fn.fnamemodify(target_file, ":p:r")

					-- Compile the program
					local compile_cmd = string.format("gcc -g %s -o %s", target_file, output_path)
					local compile_result = vim.fn.system(compile_cmd)

					if vim.v.shell_error ~= 0 then
						vim.notify("Compilation failed: " .. compile_result, vim.log.levels.ERROR)
						return
					end

					-- Run with debugger
					dap.run({
						type = "cppdbg",
						request = "launch",
						program = output_path,
						args = args,
						cwd = vim.fn.getcwd(),
						stopOnEntry = true,
						setupCommands = {
							{
								description = "enable pretty printing",
								text = "-enable-pretty-printing",
								ignoreFailures = false,
							},
						},
					})
				elseif vim.bo.filetype == "go" then
					dap.run({
						type = "delve",
						name = "Debug with args",
						request = "launch",
						program = target_file,
						args = args,
					})
				else
					vim.notify("Debugging not configured for this filetype: " .. vim.bo.filetype, vim.log.levels.ERROR)
				end
			end,
			desc = "Debug: Start/Continue with Args",
		},
		{
			"<F2>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<F3>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<leader>bb",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
		{
			"<leader>bB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Set Breakpoint",
		},
		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		{
			"<F7>",
			function()
				require("dapui").toggle()
			end,
			desc = "Debug: See last session result.",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Mason-nvim-dap setup
		require("mason").setup()
		require("mason-nvim-dap").setup({
			ensure_installed = { "cpptools", "delve" },
			automatic_installation = true,
			handlers = {
				function(config)
					-- all sources with no handler get passed here
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		})

		-- Configure C/C++ adapter
		dap.adapters.cppdbg = {
			id = "cppdbg",
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
		}

		-- Basic configurations for C/C++
		dap.configurations.c = {
			{
				name = "Launch file",
				type = "cppdbg",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = true,
				setupCommands = {
					{
						description = "enable pretty printing",
						text = "-enable-pretty-printing",
						ignoreFailures = false,
					},
				},
			},
		} -- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		-- Change breakpoint icons
		-- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
		-- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
		-- local breakpoint_icons = vim.g.have_nerd_font
		--     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
		--   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
		-- for type, icon in pairs(breakpoint_icons) do
		--   local tp = 'Dap' .. type
		--   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
		--   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
		-- end
		dap.last_args = {}
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Install golang specific config
		require("dap-go").setup({
			delve = {
				-- On Windows delve must be run attached or it crashes.
				-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
				detached = vim.fn.has("win32") == 0,
			},
		})
	end,
}
