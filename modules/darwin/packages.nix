{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dockutil # Manage icons in the dock
    restic
    appcleaner
    brave
    rclone
    ncdu
    exiftool
    hermes-agent
  ];
}
