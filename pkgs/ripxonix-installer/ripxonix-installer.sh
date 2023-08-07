#!/usr/bin/env bash

# This script is heavily inspired by the work of Martin Wimpress
# Credit: https://github.com/wimpysworld/nix-config/blob/main/nixos/_mixins/users/nixos/default.nix

#set -euo pipefail

TARGET_HOST="${1:-}"
TARGET_USER="${2:-ripxorip}"

if [ "$(id -u)" -eq 0 ]; then
  echo "ERROR! $(basename "$0") should be run as a regular user"
  exit 1
fi

if [ ! -d "$HOME/dev/ripxonix/.git" ]; then
  git clone https://github.com/ripxorip/ripxonix.git "$HOME/dev/ripxonix"
fi

pushd "$HOME/dev/ripxonix"

if [[ -z "$TARGET_HOST" ]]; then
  echo "ERROR! $(basename "$0") requires a hostname as the first argument"
  echo "       The following hosts are available"
  ls -1 nixos/*/boot.nix | cut -d'/' -f2 | grep -v iso
  exit 1
fi

if [[ -z "$TARGET_USER" ]]; then
  echo "ERROR! $(basename "$0") requires a username as the second argument"
  echo "       The following users are available"
  ls -1 nixos/_mixins/users/ | grep -v -E "nixos|root"
  exit 1
fi

if [ ! -e "nixos/$TARGET_HOST/disks.nix" ]; then
  echo "ERROR! $(basename "$0") could not find the required nixos/$TARGET_HOST/disks.nix"
  exit 1
fi

# Check if the machine we're provisioning expects a keyfile to unlock a disk.
# If it does, generate a new key, and write to a known location.
if grep -q "data.keyfile" "nixos/$TARGET_HOST/disks.nix"; then
  echo -n "$(head -c32 /dev/random | base64)" > /tmp/data.keyfile
fi

echo "WARNING! The disks in $TARGET_HOST are about to get wiped"
echo "         NixOS will be re-installed"
echo "         This is a destructive operation"
echo
read -p "Are you sure? [y/N]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo true

  sudo nix run github:nix-community/disko \
    --extra-experimental-features "nix-command flakes" \
    --no-write-lock-file \
    -- \
    --mode zap_create_mount \
    "nixos/$TARGET_HOST/disks.nix"

  sudo nixos-install --no-root-password --flake ".#$TARGET_HOST"

  sudo chown -R ${TARGET_USER}:users /mnt/home/$TARGET_USER
  # Rsync nix-config to the target install and set the remote origin to SSH.
  rsync -a --delete "$HOME/dev/" "/mnt/home/$TARGET_USER/dev/"
  pushd "/mnt/home/$TARGET_USER/dev/ripxonix"
  git remote set-url origin git@github.com:ripxorip/ripxonix.git
  popd

  # If there is a keyfile for a data disk, put copy it to the root partition and
  # ensure the permissions are set appropriately.
  if [[ -f "/tmp/data.keyfile" ]]; then
    sudo cp /tmp/data.keyfile /mnt/etc/data.keyfile
    sudo chmod 0400 /mnt/etc/data.keyfile
  fi
fi
