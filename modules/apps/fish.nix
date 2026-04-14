{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    # Твои алиасы
    shellAliases = {
      # NixOS сокращения
      nos = "nh os switch .";
      nup = "nh os switch . --update";
      nclean = "nh clean all";
      conf = "nvim ~/nixos-config"; # Путь к твоей папке с конфигом

      # Git
      gs = "git status";
      ga = "git add .";
      gc = "git commit -m";
      gp = "git push";

      # Разработка (Frontend)
      nd = "npm run dev";
      ni = "npm install";
      nb = "npm run build";

      # Утилиты
      ls = "eza --icons"; # Если используешь eza (советую)
      cat = "bat"; # Если используешь bat
      fetch = "fastfetch";

      # Профили
      p-status = "powerprofilesctl get";
      p-quiet = "powerprofilesctl set power-saver";
      p-bal = "powerprofilesctl set balanced";
      p-perf = "powerprofilesctl set performance";

      # Vim
      vim = "nvim";
      v = "nvim";

      # Обновление
      update = "nix-channel --update";
      upgrade = "nix-env -u";

      # Поиск
      f = "fd";

      # Поиск в текущем каталоге
      ff = "fd . | fzf";

      # Поиск в текущем каталоге и открытие в Vim
      fv = "fd . | fzf | xargs nvim";

    };

    # Интерактивные настройки (приветствие и т.д.)
    interactiveShellInit = ''
      set fish_greeting ""
      # Если используешь starship, инициализируем здесь
      # starship init fish | source
    '';
  };
}
