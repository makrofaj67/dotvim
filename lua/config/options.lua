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
o.signcolumn = "yes"
o.foldmethod = "manual"
o.wrap = true

g.user42 = "rakman"
g.mail42 = "rakman@student.42istanbul.com.tr"

o.undofile = true
o.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"
vim.cmd("set viminfo+=n")
if g.neovide then
	o.guifont = "CaskaydiaCove Nerd Font Mono:h11"
	g.neovide_detach_on_quit = "always_detach"
	g.neovide_scale_factor = 1.0
end

-- vim.cmd("cd /home/luka/Desktop/push_swap/")

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



vim.api.nvim_create_user_command("SilCCom", function()
    local start_line = 1
    local end_line = vim.fn.line("$")
    -- Orijinal satırları oku
    local original_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local result_lines = {}
    local in_multiline_comment = false

    for _, line in ipairs(original_lines) do
        local original = line
        -- Çok satırlı yorumları işaretle
        if in_multiline_comment then
            if line:find("*/") then
                line = line:gsub(".-%*/", "")
                in_multiline_comment = false
            else
                line = ""  -- yorumun içindeyse, tamamen sil
            end
        end

        -- Yeni çok satırlı yorum başladıysa
        if not in_multiline_comment and line:find("/%*") then
            in_multiline_comment = not line:find("%*/")
            line = line:gsub("/%*.-%*/", ""):gsub("/%*.*", "")
        end

        -- Tek satır yorumları sil
        line = line:gsub("//.*", "")

        -- Satır sadece yorum içeriyorsa ve orijinali boş değilse, atla
        if line:match("^%s*$") and not original:match("^%s*$") then
            -- sadece yorumdan oluşuyordu, atlıyoruz
        else
            table.insert(result_lines, line)
        end
    end

    -- Sonuçları buffer'a yaz
    vim.api.nvim_buf_set_lines(0, 0, -1, false, result_lines)
end, {})
