{ pkgs }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/orangci/walls/master/excalibur-lake.jpg";
    sha256 = "sha256-MNFumCJTJWOUe41LT/ryyZ6BB00XSCoUh54bUIFN2nA=";
  };
in
pkgs.writeShellScriptBin "set-wallpaper-script" ''
  set -e
  /usr/bin/osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"${wallpaper}\""
''