{ config, lib, ... }:

let
  cfg = config.jake.system.services;
in
{
  options.jake.system.services = {
    enable = lib.mkEnableOption "Включить стандартный набор системных сервисов";
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;
    services.tumbler.enable = true;

    # Виртуализация и ИИ (можно потом вынести отдельно, если будет мешать)
    virtualisation.docker.enable = true;
    services.ollama.enable = true;
  };
}
