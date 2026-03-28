# modules/apps/dev.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs
    typescript
    corepack
    git
    lazygit
    gh
    postman
    insomnia
    dbeaver-bin

    python3
    prettier
    prettierd

    # Дополнительно для работы картинок и медиа в Snacks.nvim
    imagemagick # Исправит ошибку Snacks.image (magick/convert)
    chafa # Для превью картинок в терминале
    ghostscript # Для рендеринга PDF (gs)
  ];

}
