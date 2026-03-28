{ config
, pkgs
, inputs
, ...
}:

{
  home.username = "jake";
  home.homeDirectory = "/home/jake";

  imports = [
    # Подключаем модуль plasma-manager из инпутов флаке
    inputs.plasma-manager.homeModules.plasma-manager

    ./apps/git.nix
    ./apps/ghostty.nix
    ./apps/vscode.nix
    ./apps/nvim.nix
    ./apps/fish.nix
  ];

  # --- НАСТРОЙКИ KDE PLASMA ---
  programs.plasma = {
    enable = true;

    # Горячие клавиши (открыть Ghostty и закрыть окно)
    shortcuts = {
      "services/com.mitchellh.ghostty.desktop" = {
        "_launch" = "Meta+Return";
      };
      "kwin" = {
        "Window Close" = "Meta+Q";
        "Expose" = "Meta+Tab"; # Удобный обзор всех окон
      };
    };

    # Твое предложение №2: Ночной режим по координатам Петропавловска
    kwin.nightLight = {
      enable = true;
      mode = "location";
      location = {
        latitude = "54.8";
        longitude = "69.1";
      };
    };

    # Предложение по шрифтам: ставим Inter для интерфейса
    fonts = {
      general = {
        family = "Inter";
        pointSize = 10;
      };
    };
  };

  home.packages = with pkgs; [
    nodejs_22
    nodePackages.pnpm
    nodePackages.prettier
    yarn
    lazygit
    btop
    tldr
    jq
    bibata-cursors
    telegram-desktop
    google-chrome
    inter # Шрифт Inter
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LIBSQLITE = "${pkgs.sqlite.out}/lib/libsqlite3.so";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  home.stateVersion = "25.11";
}
