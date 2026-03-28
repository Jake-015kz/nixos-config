return {
  {
    "brentsec/VimTeacher",
    -- Команда :VimTeacher станет доступна после установки
    cmd = "VimTeacher",
    keys = {
      -- Настройка горячих клавиш: Пробел + v + t
      { "<leader>vt", "<cmd>VimTeacher<cr>", desc = "Открыть VimTeacher" },
    },
  },
}
