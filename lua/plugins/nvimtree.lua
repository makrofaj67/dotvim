-- NvChad-style file explorer (nvim-tree)
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Explorer" },
  },
  opts = {
    view = { width = 30 },
    renderer = { icons = { show = { git = true, folder = true, file = true, folder_arrow = true } } },
    filters = { dotfiles = false },
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end
      vim.keymap.set('n', '.', api.tree.change_root_to_node, opts('CD into directory'))
      vim.keymap.set('n', '<BS>', api.tree.change_root_to_parent, opts('Go up (cd ..)'))
      vim.keymap.set('n', '<CR>', function()
        api.node.open.edit()
      end, opts('Open file or toggle folder'))
    end,
  },
}
