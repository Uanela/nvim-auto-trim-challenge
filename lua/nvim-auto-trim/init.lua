local M = {}

-- This now only removes trailing whitespaces but also adjust lines
-- Keep max of one line distance between lines.
-- PS: You will need to deactivate your code formatters when testing this

function M.setup()
  local api = vim.api

  api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.lua", "*.py", "*.js", "*.ts" },
    callback = function(e)
      local lines = api.nvim_buf_get_lines(e.buf, 0, -1, false)
      local cleaned = {}
      local prev_was_empty = false

      for i, line in ipairs(lines) do
        local trimmed = line:gsub("%s+$", "")
        local is_empty = #trimmed == 0

        if not is_empty then
          table.insert(cleaned, trimmed)
          prev_was_empty = false
        elseif not prev_was_empty and i ~= 1 then
          table.insert(cleaned, "")
          prev_was_empty = true
        end
      end

      api.nvim_buf_set_lines(e.buf, 0, -1, false, cleaned)
    end,
  })
end

return M
