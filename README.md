# Ripxonix
Ripxorip's NixOS &amp; Home Manager Configurations

# TODO
- [x] Create an ISO installer
  - Shall copy over the flake, secrets etc
  - Inspiration: https://www.reddit.com/r/NixOS/comments/y1xo2u/how_to_create_an_iso_with_my_config_files/ and wimpys installer scripts
- [x] The chown in the installer gets uid 1001, so a chown is needed for the config with 1000
- [x] It appears that I need to run nix profile at least once before home-manager can run? Bug?
- [x] Create Makefile targets for common nix Nixos/home-manager
- [ ] The key bootstrapper shall also copy over SSH keys for git to enable the point below
- [ ] Use a separate flake (private git repo) to store my secrets (see ryan4yin)
