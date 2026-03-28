{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Jake";
        email = "zhegan89@gmail.com";
      };
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = true;
    };
  };
}
