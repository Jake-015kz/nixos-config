# modules/apps/media.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mpv
    vlc
    yt-dlp
    haruna
  ];
}
