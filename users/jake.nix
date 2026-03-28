{ config, pkgs, ... }:

{
  users.users.jake = {
    isNormalUser = true;
    description = "Jake";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.bash; # Позже настроим fish/zsh
  };
}
