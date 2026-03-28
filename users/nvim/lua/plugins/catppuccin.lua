return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Тема должна загружаться первой
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- варианты: latte, frappe, macchiato, mocha
        transparent_background = false, -- установите true, если хотите прозрачность
        term_colors = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          -- Интеграция с which-key, который мы видели на скриншоте
          which_key = true,
        },
      })

      -- Активация темы
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
