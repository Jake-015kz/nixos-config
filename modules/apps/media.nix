# modules/apps/media.nix
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    mpv
    vlc
    yt-dlp
  ];
  virtualisation.docker.enable = true; # Для Ace Stream и контейнеров
}