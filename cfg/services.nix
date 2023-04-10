{ lib, config, pkgs, ... }:

with lib;
let
  # mbsync script for use in email service
  ms = ( pkgs.writeShellScriptBin "mbsync_helper" ''
    find ~/.config/mutt -maxdepth 1 -name '*_sync'    -exec mbsync -Vac {} \;
    find ~/.config/mutt -maxdepth 1 -name '*_notmuch' -exec notmuch --config {} new \;
  '' );
  cfg = config.services.tckmn_files;
in

{
  options.services.tckmn_files = {
    enable = mkEnableOption "file-specific services";
  };

  config = {

    services.locate = {
      enable = true;
      localuser = null;
      locate = pkgs.mlocate;
      prunePaths = [ "/tmp" "/var/tmp" "/var/cache" "/var/lock" "/var/run" "/var/spool" "/nix/store" "/mnt" ];
    };

    systemd.user.services.dunst = {
      description = "Dunst notification daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };

    systemd.user.services.mbsync = {
      description = "Sync emails and update search cache";
      startAt = "*:00/10";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${ms}/bin/mbsync_helper";
      };
      path = with pkgs; [ findutils isync notmuch ];
    };

    systemd.user.services.wallpaper = {
      description = "Randomize the wallpaper";
      startAt = "*:00";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/bin/sh -c 'for n in 0 1; do DISPLAY=:0.$n feh --randomize --bg-fill %h/img/wallpaper/*.png; done; true'";
      };
      path = with pkgs; [ feh ];
    };

    systemd.user.services.journal = mkIf cfg.enable {
      description = "Update journal indicator in status bar";
      startAt = "00:00";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.procps}/bin/pkill -RTMIN+13 i3blocks";
      };
    };

    systemd.user.services.current = mkIf cfg.enable {
      description = "Updates due dates for current tasks";
      startAt = "00:00";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/bin/sh -c 'sed -i s/$(date +%%a|tr a-z A-Z)/$(date +%%a|tr A-Z a-z)/g doc/notes/current.txt'";
      };
      path = with pkgs; [ gnused ];
    };

  };

}
