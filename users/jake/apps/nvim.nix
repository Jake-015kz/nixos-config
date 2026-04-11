{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      stylua
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      emmet-ls
      nil
      nixfmt-rfc-style
      ripgrep
      fzf
      fd
      ast-grep
      sqlite
      gcc
      gnumake
      unzip
      chafa
      viu
      imagemagick
      tailwindcss-language-server
      nodePackages.prettier
      eslint_d
    ];
  };

  xdg.configFile."nvim".source = ../../nvim;
}
