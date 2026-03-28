{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
    shellAliases = {
      v = "nvim";
      rebuild = "nh os switch /home/jake/.dotfiles";
      ff = "fastfetch";
      gc = "nh clean all";
    };
  };
}
