# modules/desktop/kde.nix
{ config, pkgs, ... }: {
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Настройка локализации для KDE
  i18n.defaultLocale = "ru_RU.UTF-8";

  environment.systemPackages = with pkgs; [
    kdePackages.spectacle 
    kdePackages.kcalc     
  ];
}