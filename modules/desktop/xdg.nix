{ pkgs, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/acestream" = [ "acestream.desktop" ];
    };
  };

  # Если самого .desktop файла в системе нет, создаем его «на лету»
  home.file.".local/share/applications/acestream.desktop".text = ''
    [Desktop Entry]
    Name=Ace Stream
    Exec=acestream-launcher %u
    Type=Application
    Terminal=false
    MimeType=x-scheme-handler/acestream;
  '';
}
