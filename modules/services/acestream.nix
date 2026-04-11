{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers."acestream-engine" = {
    image = "vstavrinov/acestream-engine";
    extraOptions = [
      "--net=host"
      "--pid=host"
    ];
    environment = {
      ACE_LIVE_BUFFER = "25";
      ACE_MAX_CONNECTIONS = "300";
    };
    volumes = [
      "/home/jake/.ACEStream:/home/acestream/.ACEStream"
      "/tmp/acestream:/tmp/acestream"
    ];
  };
}
