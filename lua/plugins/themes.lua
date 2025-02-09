-- lua/plugins/themes.lua
return {
    {
        "folke/tokyonight.nvim",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            -- vim.cmd([[colorscheme tokyonight]])
        end
    },
    -- Add other themes you want to use
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
    },
    {
        'projekt0n/github-nvim-theme',
        name = 'github-theme',
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('github-theme').setup({
                -- ...
            })
        end,
    },
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        lazy = false,
        priority = 1000,
    },
    { "ellisonleao/gruvbox.nvim" },
    { "sainnhe/everforest" },
    { "bluz71/vim-nightfly-colors" },
    { "NLKNguyen/papercolor-theme" },
    { "romainl/Apprentice" },
}
