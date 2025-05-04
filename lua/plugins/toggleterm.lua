-- Floating terminal (toggleterm)
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>tt", function() require("toggleterm").toggle(1, 20, nil, "float") end, desc = "Toggle Floating Terminal" },
  },
  opts = {
    size = 20,
    open_mapping = nil,
    direction = "float",
    float_opts = {
      border = "curved",
    },
    shade_terminals = true,
    start_in_insert = true,
    persist_size = true,
    persist_mode = true,
  },
}
