HOSTNAME = $(shell hostname)
USER = $(shell whoami)

ifndef HOSTNAME
 $(error Hostname unknown)
endif

ifndef USER
 $(error User unknown)
endif

home:
ifdef light
	home-manager switch -b backup --flake ~/dev/ripxonix/#${USER}@${HOSTNAME} --override-input darkmode_flag github:boolean-option/false
else
	home-manager switch -b backup --flake ~/dev/ripxonix/#${USER}@${HOSTNAME}
endif
# FIXME No idea why I have to issue `nix profile list` first, if I don't, I get
# no suitable profile found from home-manager?
home_build:
	sudo chown -R ripxorip:users /home/ripxorip
	nix profile list
	home-manager build -b backup --flake ~/dev/ripxonix/#${USER}@${HOSTNAME}
	-home-manager switch -b backup --flake ~/dev/ripxonix/#${USER}@${HOSTNAME}
	echo "Rebooting in 3 seconds"
	sleep 3
	sudo reboot
os:
	sudo nixos-rebuild switch --flake ~/dev/ripxonix/#${HOSTNAME}
