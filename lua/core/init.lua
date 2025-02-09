local M = {}

-- Consolidated config and utils into core/init.lua
local config_file = vim.fn.stdpath("data") .. "/theme_config.lua"

local function save_config(config)
    local file = io.open(config_file, "w")
    if file then
        local serialized = "return " .. vim.inspect(config)
        file:write(serialized)
        file:close()
    end
end

local function load_config()
    local status_ok, config = pcall(dofile, config_file)
    if status_ok then
        return config
    end
    return {}
end

local function load_theme(theme_name)
    local status_ok = pcall(vim.cmd.colorscheme, theme_name)
    if not status_ok then
        vim.notify('Theme ' .. theme_name .. ' not found! Falling back to default theme.', vim.log.levels.ERROR)
        pcall(vim.cmd.colorscheme, "default")
        return false
    end
    save_config({ theme = theme_name })
    return true
end

local function load_saved_theme()
    local saved_config = load_config()
    if saved_config.theme then
        vim.defer_fn(function()
            pcall(vim.cmd.colorscheme, saved_config.theme)
        end, 10)
    end
end

M.get_installed_themes = function()
    return vim.fn.getcompletion("", "color")
end

M.telescope_theme_switcher = function()
    local themes = M.get_installed_themes()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local current_theme = vim.g.colors_name

    pickers.new({}, {
        prompt_title = "Themes",
        finder = finders.new_table({
            results = themes,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry,
                    ordinal = entry,
                }
            end
        }),
        sorter = conf.generic_sorter({}),
        previewer = require("telescope.previewers").new_buffer_previewer({
            define_preview = function(self, entry)
                pcall(vim.cmd.colorscheme, entry.value)
                local lines = {
                    "-- Theme Preview",
                    "local function example()",
                    "    print('Hello, World!')",
                    "    return 42",
                    "end",
                }
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
                vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'lua')
            end
        }),
        attach_mappings = function(prompt_bufnr)
            actions.close:enhance({
                post = function()
                    if current_theme then
                        vim.cmd.colorscheme(current_theme)
                    end
                end,
            })
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                load_theme(selection.value)
            end)
            return true
        end,
    }):find()
end

-- Main setup function
M.setup = function()
    -- Load core options first
    require("core.options")

    -- Defer non-critical loads
    require("core.keymaps")

    -- Configure diagnostics
    vim.diagnostic.config({
        virtual_text = {
            prefix = '●',
            format = function(diagnostic)
                local code = diagnostic.code and string.format('[%s]', diagnostic.code) or ''
                return string.format('%s %s', code, diagnostic.message)
            end,
        },
        underline = false,
        update_in_insert = true,
        float = { source = 'always' },
    })

    -- Highlight priorities
    vim.highlight.priorities.semantic_tokens = 95

    -- Highlight on yank
    local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
    vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
            vim.highlight.on_yank()
        end,
        group = highlight_group,
        pattern = '*',
    })

    -- Set default colorscheme
    vim.cmd([[
        if !exists('g:colors_name')
            colorscheme default
        endif
    ]])

    -- Load saved theme
    load_saved_theme()

    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    -- Configure plugins
    require("lazy").setup({
        spec = { { import = "plugins" } },
        performance = {
            rtp = {
                disabled_plugins = {
                    "gzip", "matchit", "matchparen",
                    "netrwPlugin", "tarPlugin", "tohtml",
                    "tutor", "zipPlugin",
                },
            },
        },
        change_detection = { notify = false },
    })
end

return M