return {
    "nvim-lualine/lualine.nvim",
    config = function()
        local mode = {
            "mode",
            fmt = function(str)
                return "λ " .. str
            end,
        }

        local filename = {
            "filename",
            file_status = true,
            path = 2,
        }

        local hide_in_width = function()
            return vim.fn.winwidth(0) > 100
        end
        local diff = {
            "diff",
            colored = false,
            symbols = { added = " ", modified = " ", removed = " " },
        }

        local diagnostics = {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            colored = false,
            update_in_insert = false,
            always_visible = false,
        }

        local diagnostics = {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
            colored = false,
            update_in_insert = false,
            always_visible = false,
            cond = hide_in_width,
        }

        local diff = {
            "diff",
            colored = false,
            symbols = { added = " ", modified = " ", removed = " " },
            cond = hide_in_width,
        }

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                disabled_filetypes = { "alpha", "neo-tree" },
                always_divide_middle = true,
            },
            sections = {
                lualine_a = { mode },
                lualine_b = { "branch", diff, diagnostics },
                lualine_c = {
                    {
                        "filename",
                        color = function()
                            if vim.api.nvim_get_current_win() ~= vim.fn.win_getid() then
                                return { gui = 'italic' }
                            end
                            return nil
                        end,
                        fmt = function(str)
                            if vim.api.nvim_get_current_win() ~= vim.fn.win_getid() then
                                return str .. " •"
                            end
                            return str
                        end
                    }
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
            inactive_sections = {

                lualine_a = { mode },
				lualine_b = { "branch", diff, diagnostics },
                lualine_c = {
                    {
                        "filename",
                        color = function()
                            if not vim.api.nvim_get_current_win() ~= vim.fn.win_getid() then
                                return { gui = 'italic' }
                            end
                            return nil
                        end,
                        fmt = function(str)
                            if not vim.api.nvim_get_current_win() ~= vim.fn.win_getid() then
                                return str .. " •"
                            end
                            return str
                        end
                    }
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
            extensions = {
                {
                    filetypes = { "snacks_layout_box" },
                    sections = {
                        lualine_a = {
                            {
                                function()
                                    if vim.api.nvim_get_current_win() == vim.fn.win_getid() then
                                        return "      wake up and smell the ashes          "
                                    else
                                        return " die •"
                                    end
                                end,
                                color = function()
                                    if vim.api.nvim_get_current_win() ~= vim.fn.win_getid() then
                                        return { gui = 'italic' }
                                    end
                                    return nil
                                end
                            }
                        },
                        lualine_b = {},
                        lualine_c = {},
                        lualine_x = {},
                        lualine_y = {},
                        lualine_z = {}
                    }
                }
            }
        })
    end,
}
