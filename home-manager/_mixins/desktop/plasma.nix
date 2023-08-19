{ lib, ... }:
with lib.hm.gvariant;
{
  gtk = { };
  services.kdeconnect.enable = true;

  home.file = { };
}
