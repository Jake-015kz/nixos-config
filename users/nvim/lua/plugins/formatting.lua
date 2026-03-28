return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- Настройки форматирования
      format = {
        timeout_ms = 3000,
        async = false, -- С автосохранением лучше false, чтобы файл не "прыгал"
        quiet = false, -- Показывает ошибки, если конфиг Prettier кривой
      },
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        astro = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
      },
      -- Интеграция с LazyVim для корректной работы кнопки <leader>uf (Toggle format)
    },
  },
}
