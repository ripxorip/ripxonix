{
  description = "Ripxorips NixOS flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs at the
    # same time. See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs =
    { self
    , nix-formatter-pack
    , nixpkgs
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "23.05";
      libx = import ./lib { inherit inputs outputs stateVersion; };
      system = "x86_64-linux";

      pkgs = import.nixpkgs {
        inherit system;
        conrfig = {
          allowUnfree = true;
        };
      };

    in
    {

      nixosConfigurations = {
        ripxowork = libx.mkHost { hostname = "ripxowork"; username = "ripxorip"; desktop = "gnome"; };

        # Old configuration to fallback on for now..
        ripxonix = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit system;};
          modules = [
            ./nixos/configuration.nix
          ];
        };
      };
    };
}