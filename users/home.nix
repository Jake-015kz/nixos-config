{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  home.username = lib.mkForce "jake";
  home.homeDirectory = lib.mkForce "/home/jake";

  # --- ПРОГРАММЫ ---
  programs.ghostty = {
    enable = true;
    package = pkgs.unstable.ghostty;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  programs.neovim = {
    enable = true;

    extraPackages = with pkgs; [
      # LSP & Форматтеры (внутренние для Neovim)
      lua-language-server
      stylua
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      emmet-ls

      # Инструменты поиска
      ripgrep
      fzf
      fd
      ast-grep

      # Зависимости для Mason и плагинов
      sqlite
      luarocks
      lua51Packages.lua
      lua51Packages.jsregexp
      python311Packages.pip
      gcc
      gnumake
      nodejs_22

      # Визуализация и утилиты
      vimPlugins.nvim-treesitter.withAllGrammars
      nodePackages.mermaid-cli
      chafa
      viu
      imagemagick
      shellcheck
      shfmt
    ];
  };

  # --- ГЛОБАЛЬНЫЕ ПАКЕТЫ (Будут видны в терминале через 'which') ---
  home.packages = with pkgs; [
    # Поддержка Nix (LSP и Форматтер)
    nil
    nixfmt-rfc-style

    # Веб-инструменты
    nodePackages.prettier

    # Базовые утилиты
    git
    unzip
    wget
    curl
    lazygit
    cargo
    go
  ];

  # --- ПЕРЕМЕННЫЕ ОКРУЖЕНИЯ ---
  home.sessionVariables = {
    LIBSQLITE = "${pkgs.sqlite.out}/lib/libsqlite3.so";
    NODE_PATH = "${config.home.homeDirectory}/.npm-global/lib/node_modules";
  };

  programs.bash.enable = true;

  # Используем 24.11, так как это актуальный стабильный релиз
  home.stateVersion = "24.11";
}
