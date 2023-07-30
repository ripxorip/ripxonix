{ lib, pkgs, ... }:
{
  imports = [ ];

  systemd.user.timers."hello-world" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "hello-world.service";
    };
  };

  systemd.user.services."hello-world" = {
    script = ''
      set -eu
      ${pkgs.coreutils}/bin/echo "Hello World"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
