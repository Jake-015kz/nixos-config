{ config
, pkgs
, lib
, ...
}:

let
  cfg = config.jake.system.user;
in
{
  # Объявляем наши кастомные опции
  options.jake.system.user = {
    enable = lib.mkEnableOption "Включить настройки основного пользователя";
    userName = lib.mkOption {
      type = lib.types.str;
      default = "jake";
      description = "Имя основного пользователя";
    };
  };

  # Конфигурация применяется, только если jake.system.user.enable = true
  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = "Jake";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "audio"
        "input"
        "docker"
        "libvirtd"
        "gamemode"
      ];
      shell = pkgs.fish;
    };

    # Избавляемся от хардкода пути в flake
    environment.sessionVariables = {
      NH_FLAKE = "/home/${cfg.userName}/.dotfiles";
    };
  };
}
