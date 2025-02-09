-- lua/plugins/themes.lua
return {
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            -- vim.cmd([[colorscheme tokyonight]])
        end,
        colorschemes = { "tokyonight", "tokyonight-night", "tokyonight-storm", "tokyonight-day", "tokyonight-moon" },
    },
    -- Add other themes you want to use
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        colorschemes = { "catppuccin", "catppuccin-latte", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha" },
    },
}
