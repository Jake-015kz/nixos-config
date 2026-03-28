{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      christian-kohler.path-intellisense
      formulahendry.auto-rename-tag
    ];
  };
}
