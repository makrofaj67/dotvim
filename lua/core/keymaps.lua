-- Add this to your keymaps configuration
vim.keymap.set('n', '<leader>th', function()
    require("core.utils").telescope_theme_switcher()
end, { desc = "Select Theme" })
