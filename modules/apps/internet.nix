{pkgs, ...}:

{
    environment.systemPackages = with pkgs; [
        firefox
        brave
        qbittorrent
        google-chrome
        telegram-desktop
    ];
}
