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
    environment.etc = {
      "niri/config.kdl".source = ./config.kdl;
      "niri/modules/input.kdl".source = ./modules/input.kdl;
      "niri/modules/layout.kdl".source = ./modules/layout.kdl;
      "niri/modules/styling.kdl".source = ./modules/styling.kdl;
      "niri/modules/binds.kdl".source = ./modules/binds.kdl;
      "niri/modules/rules.kdl".source = ./modules/rules.kdl;
      "niri/modules/outputs.kdl".source = ./modules/outputs.kdl;
    };

    systemd.user.tmpfiles.rules = [
      "L+ %h/.config/niri/config.kdl - - - - /etc/niri/config.kdl"
      "L+ %h/.config/niri/modules/outputs.kdl - - - - /etc/niri/modules/outputs.kdl"
      "L+ %h/.config/niri/modules/input.kdl - - - - /etc/niri/modules/input.kdl"
      "L+ %h/.config/niri/modules/layout.kdl - - - - /etc/niri/modules/layout.kdl"
      "L+ %h/.config/niri/modules/styling.kdl - - - - /etc/niri/modules/styling.kdl"
      "L+ %h/.config/niri/modules/binds.kdl - - - - /etc/niri/modules/binds.kdl"
      "L+ %h/.config/niri/modules/rules.kdl - - - - /etc/niri/modules/rules.kdl"
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
    };
  };
}
