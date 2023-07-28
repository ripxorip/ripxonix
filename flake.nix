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

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

  };
  outputs =
    { self
    , nix-formatter-pack
    , home-manager
    , nixpkgs
    , agenix
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "23.05";

      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
      inherit lib;
      # nix fmt
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });

      # The home-manager configurations (e.g): home-manager switch --flake ~/dev/ripxonix/#ripxorip@ripxowork
      homeConfigurations = {
        "ripxorip@ripxowork" = lib.homeManagerConfiguration {
          modules = [
            ./home-manager
          ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion;
            desktop = "gnome";
            hostname = "ripxowork";
            platform = "x86_64-linux";
            username = "ripxorip";
          };
        };
      };

      # The NixOS configurations
      nixosConfigurations =
        let
          iso_params = {
            services.xserver.displayManager.autoLogin.user = lib.mkForce "ripxorip";
            isoImage.squashfsCompression = "gzip -Xcompression-level 1";
          };
        in
        {
          #sudo nixos-rebuild switch --flake ~/dev/ripxonix/#ripxowork
          ripxowork = lib.nixosSystem {
            modules = [
              ./nixos
              agenix.nixosModules.age
            ];
            specialArgs = {
              inherit inputs outputs stateVersion;
              hostname = "ripxowork";
              username = "ripxorip";
              desktop = "gnome";
            };
          };
          # Build using: nix build .#nixosConfigurations.iso-desktop.config.system.build.isoImage 
          # Handy debug tip: nix eval .#nixosConfigurations.iso-desktop.config.isoImage.squashfsCompression
          iso-desktop = lib.nixosSystem {
            modules = [
              ./nixos
              agenix.nixosModules.age
              (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix")
              iso_params
              home-manager.nixosModules.home-manager
              {
                home-manager.users.ripxorip = {
                  imports = [
                    ./home-manager
                  ];
                };
                home-manager.extraSpecialArgs = {
                  inherit inputs outputs stateVersion;
                  desktop = "gnome";
                  hostname = "iso-desktop";
                  username = "ripxorip";
                };
              }
            ];
            specialArgs = {
              inherit inputs outputs stateVersion;
              hostname = "iso-desktop";
              username = "ripxorip";
              desktop = "gnome";
            };
          };
        };
    };
}
