require("config.smartescape")
vim.g.smart_escape_timeout = 200 -- milliseconds
vim.g.smart_escape_visual_feedback = true
-- Keyboard users
vim.keymap.set("n", "<C-t>", function()
	require("menu").open("default")
end, {})

-- mouse users + nvimtree users!
vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
	require("menu.utils").delete_old_menus()

	vim.cmd.exec('"normal! \\<RightMouse>"')

	-- clicked buf
	local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
	local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

	require("menu").open(options, { mouse = true })
end, {})
-- Keyboard users

-- -- Disable the spacebar key's default behavior in Normal and Visual modes
-- vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
--
-- -- For conciseness
-- local opts = { noremap = true, silent = true }
-- vim.api.nvim_set_keymap("n", "<leader>ft", ":ToggleTerm direction=float<CR>", { noremap = true, silent = true })
--
-- -- save file
-- vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", opts)
--
-- -- save file without auto-formatting
-- vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)
--
-- -- quit file
-- vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", opts)
--
-- -- delete single character without copying into register
-- vim.keymap.set("n", "x", '"_x', opts)
--
-- -- Vertical scroll and center
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
--
-- -- Find and center
-- vim.keymap.set("n", "n", "nzzzv", opts)
-- vim.keymap.set("n", "N", "Nzzzv", opts)
--
-- -- Resize with arrows
-- vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
-- vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
-- vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
-- vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)
--
-- -- Buffers
-- vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
-- vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
-- vim.keymap.set("n", "<leader>x", ":bdelete!<CR>", opts) -- close buffer
-- vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer
--
-- -- Window management
-- vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
-- vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
-- vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
-- vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window
--
-- -- Navigate between splits
-- vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
-- vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
-- vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
-- vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)
--
-- -- Tabs
-- vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
-- vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
-- vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
-- vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab
--
-- -- Toggle line wrapping
-- vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)
--
-- -- Stay in indent mode
-- vim.keymap.set("v", "<", "<gv", opts)
-- vim.keymap.set("v", ">", ">gv", opts)
--
-- -- Keep last yanked when pasting
-- vim.keymap.set("v", "p", '"_dP', opts)
--
-- -- Diagnostic keymaps
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
-- vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
--
