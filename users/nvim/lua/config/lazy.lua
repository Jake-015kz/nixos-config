local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Добавляем LazyVim и его плагины
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- ВКЛЮЧАЕМ ПОДДЕРЖКУ ТВОИХ СТЕКОВ:
    { import = "lazyvim.plugins.extras.coding.blink" }, -- Убедимся что блинк активен
    { import = "lazyvim.plugins.extras.lang.typescript" }, -- TSX/JSX
    { import = "lazyvim.plugins.extras.lang.tailwind" }, -- Tailwind CSS
    { import = "lazyvim.plugins.extras.lang.json" }, -- JSON
    { import = "lazyvim.plugins.extras.linting.eslint" }, -- eslint

    -- ТВОЯ НАСТРОЙКА СНИППЕТОВ:
    {
      "L3MON4D3/LuaSnip",
      opts = function(_, opts)
        require("luasnip.loaders.from_vscode").lazy_load({
          paths = { vim.fn.stdpath("config") .. "/snippets" },
        })
      end,
    },

    -- Импортируем твои кастомные плагины из папки plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
