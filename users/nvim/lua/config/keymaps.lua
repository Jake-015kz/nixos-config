-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- 1. Выход из режима вставки на jk
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit Insert Mode" })

-- 2. Навигация между окнами (Ctrl + h/j/k/l)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Настройки Codeium (ИИ подсказки)
vim.keymap.set("i", "<M-l>", function()
  return require("codeium.virtual_text").accept()
end, { expr = true, silent = true, desc = "Codeium Accept" })

-- Листать варианты (Alt + [ и Alt + ])
vim.keymap.set("i", "<M-]>", function()
  return require("codeium.virtual_text").cycle_completions(1)
end, { expr = true })
vim.keymap.set("i", "<M-[>", function()
  return require("codeium.virtual_text").cycle_completions(-1)
end, { expr = true })

-- 4. УМНЫЙ ENTER (Разнос тегов и скобок как в WebStorm)
-- Работает только в режиме вставки, не ломает командную строку
vim.keymap.set("i", "<cr>", function()
  -- Получаем текущую строку и позицию курсора
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- Символы непосредственно до и после курсора
  local char_before = line:sub(col, col)
  local char_after = line:sub(col + 1, col + 1)

  -- Если мы находимся между тегами >< или скобками {}
  if
    (char_before == ">" and char_after == "<")
    or (
      char_before == "{" and char_after == "}"
      or char_before == "[" and char_after == "]"
      or char_before == "(" and char_before == ")"
    )
  then
    -- Нажимаем Enter, выходим в Normal, создаем строку выше (O) и остаемся в Insert
    return "<cr><esc>O"
  end

  -- В остальных случаях — обычный Enter
  return "<cr>"
end, { expr = true, replace_keycodes = true, desc = "Smart Enter for Tags/Brackets" })
