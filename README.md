# Ripxonix
Ripxorip's NixOS &amp; Home Manager Configurations

## Usage ⚒️
``````make
# Rebuild the OS
make os
# Initial build of the home environment
make home_build
# Rebuild the home environment
make home
``````
### Build the ISO 💿
`nix build .#nixosConfigurations.iso-desktop.config.system.build.isoImage`

## TODOs
- [ ] The key bootstrapper shall also copy over SSH keys for git to enable the point below
- [ ] Use a separate flake (private git repo) to store my secrets (see ryan4yin)

## Inspirations 🖋️
- Wimpy https://github.com/wimpysworld/nix-config
- Misterio77 https://github.com/Misterio77/nix-starter-configs