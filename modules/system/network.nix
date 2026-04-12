{ config, lib, ... }:

let
  cfg = config.jake.system.network;
in
{
  options.jake.system.network = {
    enable = lib.mkEnableOption "Включить базовые настройки сети";
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "Имя хоста машины";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hostName = cfg.hostName;
    networking.networkmanager.enable = true;
    networking.networkmanager.dns = "systemd-resolved";
    services.resolved.enable = true;
  };
}
