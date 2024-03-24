{ pkgs, ... }:
{
  systemd.timers.feed_fencer = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar="*-*-* *:*:00";
      Persistant = true;
      Unit = "feed_fencer.service";
    };
  };

  # This needs my full environment, hmm, user service instead? Needs som more investigation!
  systemd.services.feed_fencer = {
    unitConfig = {
      Description = "The Feed fencer";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.feed_fencer}/bin/feed_fencer";
    };
  };
}
