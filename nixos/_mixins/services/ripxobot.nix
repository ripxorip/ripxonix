{ pkgs, ... }:
{
  systemd.timers.ripxobot-housekeeper = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistant = true;
      Unit = "ripxobot-housekeeper.service";
    };
  };

  # This needs my full environment, hmm, user service instead? Needs som more investigation!
  systemd.services.ripxobot-housekeeper = {
    path = [ "/run/wrappers/" pkgs.coreutils pkgs.gawk pkgs.syncoid pkgs.tailscale pkgs.matrix-sh pkgs.zfs pkgs.docker pkgs.curl pkgs.unixtools.ping ];
    unitConfig = {
      Description = "The ripxobot housekeeper";
      Requires = [ "local-fs.targetz" ];
      After = [ "local-fs.target" ];
    };
    serviceConfig = {
      User = "ripxorip";
      Type = "oneshot";
      ExecStart = "${pkgs.python3}/bin/python /home/ripxorip/dev/ripxobot/ripxobot.py";
      WorkingDirectory = "/home/ripxorip/dev/ripxobot/";
    };
  };
}
