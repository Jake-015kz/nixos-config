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
  ];

  programs.plasma = {
    enable = true;

    # Вместо kwin.effects используем прямой конфиг, чтобы не ловить ошибки опций
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

  home.packages = with pkgs; [
    jq
    bibata-cursors
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
