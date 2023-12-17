{
  description = "Ripxorips NixOS flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # You can access packages and modules from different nixpkgs revs at the
    # same time. See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";
    nix-formatter-pack.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    waveforms.url = "github:ripxorip/waveforms-flake";
    waveforms.inputs.nixpkgs.follows = "nixpkgs";

    talon-nix.url = "github:nix-community/talon-nix";
    talon-nix.inputs.nixpkgs.follows = "nixpkgs";

    darkmode_flag.url = "github:boolean-option/true";

  };
  outputs =
    { self
    , nix-formatter-pack
    , home-manager
    , nixpkgs
    , nixos-hardware
    , agenix
    , talon-nix
    , waveforms
    , darkmode_flag
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "23.11";

      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
      pkgsFor = nixpkgs.legacyPackages;
      darkmode = darkmode_flag.value;
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
        "ripxorip@ripxostation" = lib.homeManagerConfiguration {
          modules = [
            ./home-manager
          ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion darkmode;
            desktop = "gnome";
            hostname = "ripxostation";
            platform = "x86_64-linux";
            username = "ripxorip";
          };
        };
        "ripxorip@ripxowork" = lib.homeManagerConfiguration {
          modules = [
            ./home-manager
          ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion darkmode;
            desktop = "gnome";
            hostname = "ripxowork";
            platform = "x86_64-linux";
            username = "ripxorip";
          };
        };
        "ripxorip@ripxolab" = lib.homeManagerConfiguration {
          modules = [
            ./home-manager
          ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion darkmode;
            desktop = "gnome";
            hostname = "ripxolab";
            platform = "x86_64-linux";
            username = "ripxorip";
          };
        };
        "ripxorip@vm" = lib.homeManagerConfiguration {
          modules = [
            ./home-manager
          ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion darkmode;
            desktop = "plasma";
            hostname = "vm";
            platform = "x86_64-linux";
            username = "ripxorip";
          };
        };
        "ripxorip@ripxopad" = lib.homeManagerConfiguration {
          modules = [
            ./home-manager
          ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion darkmode;
            desktop = "gnome";
            hostname = "ripxopad";
            platform = "x86_64-linux";
            username = "ripxorip";
          };
        };
        "ripxorip@ripxonode" = lib.homeManagerConfiguration {
          modules = [
            ./home-manager
          ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion darkmode;
            hostname = "ripxonode";
            platform = "x86_64-linux";
            username = "ripxorip";
            desktop = null;
          };
        };
        "ripxorip@mserver" = lib.homeManagerConfiguration {
          modules = [
            ./home-manager
          ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs stateVersion darkmode;
            hostname = "mserver";
            platform = "x86_64-linux";
            username = "ripxorip";
            desktop = null;
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
          ripxostation = lib.nixosSystem {
            modules = [
              ./nixos
              agenix.nixosModules.age
              talon-nix.nixosModules.talon
            ];
            specialArgs = {
              inherit inputs outputs stateVersion;
              hostname = "ripxostation";
              username = "ripxorip";
              desktop = "gnome";
            };
          };
          ripxowork = lib.nixosSystem {
            modules = [
              ./nixos
              agenix.nixosModules.age
              nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
              waveforms.nixosModule
              talon-nix.nixosModules.talon
            ];
            specialArgs = {
              inherit inputs outputs stateVersion;
              hostname = "ripxowork";
              username = "ripxorip";
              desktop = "gnome";
            };
          };
          ripxolab = lib.nixosSystem {
            modules = [
              ./nixos
              agenix.nixosModules.age
            ];
            specialArgs = {
              inherit inputs outputs stateVersion;
              hostname = "ripxolab";
              username = "ripxorip";
              desktop = "gnome";
            };
          };
          vm = lib.nixosSystem {
            modules = [
              ./nixos
              agenix.nixosModules.age
            ];
            specialArgs = {
              inherit inputs outputs stateVersion;
              hostname = "vm";
              username = "ripxorip";
              desktop = "plasma";
            };
          };
          ripxopad = lib.nixosSystem {
            modules = [
              ./nixos
              agenix.nixosModules.age
            ];
            specialArgs = {
              inherit inputs outputs stateVersion;
              hostname = "ripxopad";
              username = "ripxorip";
              desktop = "gnome";
            };
          };
          ripxonode = lib.nixosSystem {
            modules = [
              ./nixos
              agenix.nixosModules.age
            ];
            specialArgs = {
              inherit inputs outputs stateVersion;
              hostname = "ripxonode";
              username = "ripxorip";
              desktop = null;
            };
          };
          mserver = lib.nixosSystem {
            modules = [
              ./nixos
              agenix.nixosModules.age
            ];
            specialArgs = {
              inherit inputs outputs stateVersion;
              hostname = "mserver";
              username = "ripxorip";
              desktop = null;
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
                  inherit inputs outputs stateVersion darkmode;
                  desktop = "gnome";
                  hostname = "iso-desktop";
                  username = "ripxorip";
                };
              }
            ];
            specialArgs = {
              inherit inputs outputs stateVersion darkmode;
              hostname = "iso-desktop";
              username = "ripxorip";
              desktop = "gnome";
            };
          };
        };
    };
}
