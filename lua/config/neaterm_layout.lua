-- Neaterm layout persistence helper
local M = {}

local layout_file = vim.fn.stdpath("data") .. "/neaterm_layout.json"

function M.save_layout(float_width, float_height)
  local f = io.open(layout_file, "w")
  if f then
    f:write(vim.fn.json_encode({float_width=float_width, float_height=float_height}))
    f:close()
  end
end

function M.load_layout()
  local f = io.open(layout_file, "r")
  if f then
    local content = f:read("*a")
    f:close()
    local ok, data = pcall(vim.fn.json_decode, content)
    if ok and data then
      return data.float_width, data.float_height
    end
  end
  return nil, nil
end

function M.setup()
  local loaded_width, loaded_height = M.load_layout()
  if loaded_width and loaded_height then
    require("neaterm").setup({
      default_opts = {
        float_width = loaded_width,
        float_height = loaded_height,
      }
    })
  end
  vim.api.nvim_create_autocmd("User", {
    pattern = "NeatermResized",
    callback = function()
      local float_width = require("neaterm").config.float_width
      local float_height = require("neaterm").config.float_height
      M.save_layout(float_width, float_height)
    end,
  })
end

return M
