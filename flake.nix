{
  description = "Jake's Modular NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Тот самый "AUR" для ядер CachyOS
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , chaotic
    , home-manager
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations.jake-pc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          # Подключаем оверлей и модули Chaotic
          { nixpkgs.overlays = [ overlay-unstable ]; }
          chaotic.nixosModules.default

          ./hosts/jake-pc/config.nix
          home-manager.nixosModules.home-manager

          # Настройка ядра: ставим CachyOS и включаем кэш
          (
            { pkgs, ... }:
            {
              boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;
              chaotic.nyx.cache.enable = true;
            }
          )
        ];
      };
    };
}
