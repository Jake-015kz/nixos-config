{ config
, pkgs
, inputs
, ...
}:

{
  home.username = "jake";
  home.homeDirectory = "/home/jake";

  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ./apps/git.nix
    ./apps/ghostty.nix
    ./apps/vscode.nix
    ./apps/nvim.nix
    ./apps/fish.nix
    ./apps/fuzzel.nix
  ];

  programs.plasma = {
    enable = true;

    # Конфиг эффектов напрямую
    configFile."kwinrc"."Plugins"."blurEnabled" = true;
    configFile."kwinrc"."Plugins"."magiclampEnabled" = true;

    # Настройка панелей (Floating Panel)
    panels = [
      {
        location = "bottom";
        height = 42;
        floating = true;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    # Горячие клавиши
    shortcuts = {
      "services/com.mitchellh.ghostty.desktop" = {
        "_launch" = "Meta+Return";
      };
      "kwin" = {
        "Window Close" = "Meta+Q";
        "Expose" = "Meta+Tab";
      };
    };

    # Ночной режим
    kwin.nightLight = {
      enable = true;
      mode = "location";
      location = {
        latitude = "54.8";
        longitude = "69.1";
      };
    };

    # Шрифты
    fonts = {
      general = {
        family = "Inter";
        pointSize = 10;
      };
    };
  };

  # Объединенный список пакетов
  home.packages = with pkgs; [
    jq
    bibata-cursors
    # Наш скрипт-обработчик AceStream
    (writeShellScriptBin "acestream-open" ''
      ID=$(echo "$1" | sed 's|acestream://||; s|/||g')
      ${pkgs.mpv}/bin/mpv "http://127.0.0.1:6878/ace/getstream?id=$ID"
    '')
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

  # Настройка ассоциаций для ссылок (MIME types)
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/acestream" = [ "acestream.desktop" ];
    };
  };

  # Создаем desktop-файл для системы
  xdg.desktopEntries."acestream" = {
    name = "Ace Stream";
    exec = "acestream-open %u";
    mimeType = [ "x-scheme-handler/acestream" ];
    terminal = false;
    categories = [
      "AudioVideo"
      "Video"
      "Player"
    ];
  };

  home.stateVersion = "25.11";
}
