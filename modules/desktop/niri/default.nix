{ config
, pkgs
, inputs
, lib
, ...
}:

let
  cfg = config.jake.desktop.niri;
in
{
  options.jake.desktop.niri = {
    enable = lib.mkEnableOption "Niri compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;

    services.logind.settings.Login.HandleLidSwitch = "ignore";
    services.displayManager = {
      autoLogin.enable = true;
      autoLogin.user = config.jake.system.user.userName;
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "niri";
    };

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.system}.default
      xwayland
      swaynotificationcenter
      fuzzel
      networkmanagerapplet
      wireplumber
      brightnessctl
      playerctl
      grim
      slurp
      wl-clipboard
      wlogout
      swaylock
    ];

    # Подключаем внешний KDL файл
    environment.etc."niri/config.kdl".source = ./config.kdl;

    # Создаем симлинк в домашнюю папку для работы конфига "на лету"
    systemd.user.tmpfiles.rules = [
      "L+ %h/.config/niri/config.kdl - - - - /etc/niri/config.kdl"
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
    };
  };
}
