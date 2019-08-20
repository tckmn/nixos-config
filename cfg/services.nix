{ config, pkgs, ... }:

{
  services.locate = {
    enable = true;
    localuser = null;
    locate = pkgs.mlocate;
    prunePaths = [ "/tmp" "/var/tmp" "/var/cache" "/var/lock" "/var/run" "/var/spool" "/nix/store" "/mnt" ];
  };

  systemd.user.services.journal = {
    enable = true;
    description = "Update journal indicator in status bar";
    startAt = "00:00";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.procps}/bin/pkill -RTMIN+13 i3blocks";
    };
  };

  systemd.user.services.mbsync = {
    enable = true;
    description = "Sync emails and update search cache";
    startAt = "*:00/10";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "%h/bin/ms";
    };
    path = with pkgs; [ isync notmuch ];
  };

  systemd.user.services.wallpaper = {
    enable = true;
    description = "Randomize the wallpaper";
    startAt = "*:00";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c 'for n in 0 1; do DISPLAY=:0.$n feh --randomize --bg-fill %h/img/wallpaper/*.png; done; true'";
    };
    path = with pkgs; [ feh ];
  };
}
