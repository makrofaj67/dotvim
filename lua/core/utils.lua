-- lua/options/utils.lua
local M = {}

local config = require("core.config")

-- lua/options/utils.lua


-- Function to load and apply a colorscheme
M.load_theme = function(theme_name)
local status_ok, _ = pcall(vim.cmd.colorscheme, theme_name)
if not status_ok then
    vim.notify('Theme ' .. theme_name .. ' not found! Falling back to default theme.', vim.log.levels.ERROR)
    -- Try to load a default theme
    pcall(vim.cmd.colorscheme, "default")
    return false
    end

    -- Save the theme configuration
    config.save_config({ theme = theme_name })
    return true
    end

    -- Function to load the saved theme
    M.load_saved_theme = function()
    local saved_config = config.load_config()
    if saved_config.theme then
        -- Add a small delay to ensure themes are loaded
        vim.defer_fn(function()
        local status_ok, _ = pcall(vim.cmd.colorscheme, saved_config.theme)
        if not status_ok then
            vim.notify('Saved theme ' .. saved_config.theme .. ' not found! Falling back to default theme.', vim.log.levels.WARN)
            -- Try to load a default theme
            pcall(vim.cmd.colorscheme, "default")
            end
            end, 10)
        end
        end

        -- Function to get list of installed colorschemes
        M.get_installed_themes = function()
        local lazy_config = require("lazy.core.config")
        local themes = {}

        -- Loop through all installed plugins
        for _, plugin in pairs(lazy_config.plugins) do
            -- Check if the plugin contains colorschemes
            local colorschemes = plugin.colorschemes
            if colorschemes then
                for _, scheme in ipairs(colorschemes) do
                    table.insert(themes, scheme)
                    end
                    end
                    end

                    return themes
                    end

                    M.telescope_theme_switcher = function()
                    local themes = M.get_installed_themes()
                    local pickers = require("telescope.pickers")
                    local finders = require("telescope.finders")
                    local conf = require("telescope.config").values
                    local actions = require("telescope.actions")
                    local action_state = require("telescope.actions.state")
                    local previewers = require("telescope.previewers")

                    -- Save the current colorscheme to restore if canceled
                    local current_theme = vim.g.colors_name

                    -- Create custom previewer
                    local theme_previewer = previewers.new_buffer_previewer({
                        define_preview = function(self, entry)
                        -- Apply the colorscheme in preview
                        local status_ok, _ = pcall(vim.cmd.colorscheme, entry.value)
                        if not status_ok then
                            vim.notify('Theme ' .. entry.value .. ' not found!', vim.log.levels.ERROR)
                            return
                            end

                            -- Add some sample text to the preview buffer
                            local lines = {
                                "-- Theme Preview",
                                "local function example()",
                                                                            "    local number = 42",
                                                                            "    print('Hello, World!')",
                                                                            "    return true",
                                                                            "end",
                                                                            "",
                                                                            "-- Comments look like this",
                                                                            "local str = 'This is a string'",
                                                                            "local num = 100",
                                                                            "local bool = true",
                                                                            "local table = { key = 'value' }",
                                                                            "",
                                                                            "if condition then",
                                                                            "    do_something()",
                                                                            "else",
                                                                            "    do_other_thing()",
                                                                            "end",
                            }
                            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)

                            -- Set the filetype to Lua for syntax highlighting
                            vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'lua')
                            end
                    })

                    -- Create the picker
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
                                previewer = theme_previewer,
                                attach_mappings = function(prompt_bufnr, map)
                                -- Restore the previous theme if picker is canceled
                                actions.close:enhance({
                                    post = function()
                                    if current_theme then
                                        vim.cmd.colorscheme(current_theme)
                                        end
                                        end,
                                })

                                -- Apply theme on selection
                                actions.select_default:replace(function()
                                actions.close(prompt_bufnr)
                                local selection = action_state.get_selected_entry()
                                M.load_theme(selection.value)
                                end)
                                return true
                                end,
                    }):find()
                    end

                    return M
