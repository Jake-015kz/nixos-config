{
  description = "Jake's Modular NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , chaotic
    , noctalia
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
        # Добавляем inputs в specialArgs, чтобы plasma-manager был доступен везде
        specialArgs = { inherit inputs; };
        modules = [
          chaotic.nixosModules.default
          { nixpkgs.overlays = [ overlay-unstable ]; }

          ./hosts/jake-pc/config.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
