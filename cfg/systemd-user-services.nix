{ config, pkgs, ... }:

{
  systemd.user.services.journal = {
    enable = true;
    description = "Update journal indicator in status bar";
    startAt = "*-*-* 00:00:00";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.procps}/bin/pkill -RTMIN+13 i3blocks";
    };
  };

  systemd.user.services.mbsync = {
    enable = true;
    description = "Sync emails and update search cache";
    startAt = "minutely";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "%h/bin/ms";
    };
  };

  systemd.user.services.wallpaper = {
    enable = true;
    description = "Randomize the wallpaper";
    startAt = "hourly";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/usr/bin/env bash -c 'for n in 0 1; do DISPLAY=:0.$n feh --randomize --bg-fill %h/img/wallpaper/*.png; done; true'";
    };
  };
}
