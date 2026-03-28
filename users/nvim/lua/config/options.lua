-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- 1. Настройки интерфейса (фиксим невидимые линии)
vim.opt.fillchars = {
  vert = "│", -- Сплошная вертикальная линия между окнами
  horiz = "─", -- Горизонтальная линия
  eob = " ", -- Скрываем тильды (~) в пустых строках в конце файла
}

-- Делаем разделитель видимым (серый цвет)
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#444444", bold = true })

-- 2. Глобальная статусная строка (как в современных IDE)
vim.opt.laststatus = 3

-- 3. Твоя автокоманда на автосохранение
vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
  callback = function()
    -- Проверяем, что это обычный файл (не дерево файлов, не терминал) и он изменен
    if vim.bo.modified and vim.bo.buftype == "" then
      vim.cmd("silent! update")
    end
  end,
})

-- 4. Улучшенный перенос строк (Style: VS Code)
vim.opt.wrap = true -- Включаем перенос длинных строк
vim.opt.breakindent = true -- Перенесенная строка сохраняет отступ (лесенку)
vim.opt.linebreak = true -- Не разрываем слова при переносе
vim.opt.showbreak = "↳ " -- Символ в начале перенесенной строки
vim.opt.cpoptions:append("I") -- Корректная работа отступов при вставке

-- 5. Комфорт навигации и визуализация
vim.opt.scrolloff = 10 -- Курсор всегда держится в центре (10 строк запаса сверху/снизу)
vim.opt.sidescrolloff = 8 -- То же самое для горизонтали (исправлено)
vim.opt.cursorline = true -- Подсветка строки, где ты сейчас находишься
vim.opt.mouse = "a" -- Полная поддержка мыши (скролл, клики)

-- 6. Настройки отступов (Стандарт индустрии)
vim.opt.smartindent = true -- Умные отступы при создании новых строк
vim.opt.expandtab = true -- Использовать пробелы вместо табуляции
vim.opt.shiftwidth = 2 -- Размер отступа (2 пробела)
vim.opt.tabstop = 2 -- Визуальный размер таба
vim.opt.softtabstop = 2 -- Размер таба при редактировании

-- Перемещение строк вверх/вниз (Alt + j/k) как в VS Code
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Быстрое дублирование строк (Ctrl + d не советую, оно для скролла, лучше Alt + d)
vim.keymap.set("n", "<A-d>", "yyp", { desc = "Duplicate Line" })
vim.keymap.set("i", "<A-d>", "<esc>yypgi", { desc = "Duplicate Line" })

-- Центрирование экрана при быстром скролле (Ctrl+d / Ctrl+u)
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Быстрый переход в начало/конец строки (удобнее, чем 0 и $)
vim.keymap.set({ "n", "v" }, "H", "^", { desc = "Start of Line" })
vim.keymap.set({ "n", "v" }, "L", "$", { desc = "End of Line" })
