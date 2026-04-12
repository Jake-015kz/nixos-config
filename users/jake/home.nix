{ config
, pkgs
, inputs
, ...
}:

{
  home.username = "jake";
  home.homeDirectory = "/home/jake";

  imports = [
    ./apps/git.nix
    ./apps/ghostty.nix
    ./apps/vscode.nix
    ./apps/nvim.nix
    ./apps/fish.nix
    ./apps/fuzzel.nix
  ];

  # --- ПАКЕТЫ ---
  home.packages = with pkgs; [
    jq
    bibata-cursors
    noto-fonts-color-emoji # Необходим для корректного отображения флагов
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

  # Создаем desktop-файл для Ace Stream
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
