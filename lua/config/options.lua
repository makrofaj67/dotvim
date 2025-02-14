vim.o.linebreak = true
vim.o.mouse = "a"

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.opt.termguicolors = true

vim.o.swapfile = false

vim.o.showtabline = 2

vim.o.completeopt = "menuone,noselect"

local o = vim.o
local g = vim.g

o.clipboard = "unnamedplus"
o.cursorlineopt = "both"
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.expandtab = false
o.relativenumber = true
o.number = true
o.ruler = true
o.scrolloff = 20
o.signcolumn = "yes"
o.foldmethod = "manual"
o.signcolumn = "yes"
o.wrap = false

g.user42 = "rakman"
g.mail42 = "rakman@student.42istanbul.com.tr"

o.undofile = true
o.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"

if g.neovide then
	o.guifont = "CaskaydiaCove Nerd Font Mono:h11"
	g.neovide_detach_on_quit = "always_detach"
	g.neovide_scale_factor = 1.0
end

vim.cmd("cd /home/luka/.config/nvim")

vim.cmd([[
  set winblend=0
  highlight FloatBorder guifg=LightGrey guibg=NONE
]])

local border = {
	{ "╭", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╮", "FloatBorder" },
	{ "│", "FloatBorder" },
	{ "╯", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╰", "FloatBorder" },
	{ "│", "FloatBorder" },
}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
