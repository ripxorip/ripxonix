HOSTNAME = $(shell hostname)
USER = $(shell whoami)

ifndef HOSTNAME
 $(error Hostname unknown)
endif

ifndef USER
 $(error User unknown)
endif

home:
	home-manager switch -b backup --flake ~/dev/ripxonix/#${USER}@${HOSTNAME}
home_build:
	sudo chown -R ripxorip:users /home/ripxorip
	nix profile list
	nix profile --help
	home-manager build -b backup --flake ~/dev/ripxonix/#${USER}@${HOSTNAME}
os:
	sudo nixos-rebuild switch --show-trace --flake ~/dev/ripxonix/#${HOSTNAME}
