{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  user = "skjoedt";
  # Import the wallpaper script here
  wallpaperScript = import ./wallpaper.nix { inherit pkgs; };
in
{
  imports = [
    ./dock
  ];

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    # This is a module from nix-darwin
    # Homebrew is *installed* via the flake input nix-homebrew

    # These App Store IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };
    # taps = []; # <- taps are managed in flake.nix as declarative homebrew taps.
    extraConfig = ''
      cask "mediosz/tap/swipeaerospace", trusted: true
    '';
    brews = [
      "lxc"
    ];
    #masApps = {
    #  "hidden-bar"   = 1452453066;
    #  "wireguard"    = 1451685025;
    #};
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs user; };
    users.${user} =
      { pkgs, lib, ... }:
      {
        imports = [
          ../shared/home-manager.nix
          ./packages.nix
          ./files.nix
          ./home-manager-programs.nix
          ./home-manager-services.nix
        ];

        home = {
          enableNixpkgsReleaseCheck = false;
          packages = [ wallpaperScript ];

          activation = {
            setWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              $DRY_RUN_CMD ${wallpaperScript}/bin/set-wallpaper-script
            '';
          };
          stateVersion = "25.11";
        };
      };
  };

  # Fully declarative dock using the latest from Nix Stor
  local.dock = {
    enable = true;
    username = user;
    entries = [
      { path = "/Applications/Google Chrome.app/"; }
      { path = "/Applications/Apps.app/"; }
      { path = "/Applications/Ghostty.app/"; }
      { path = "/Applications/Discord.app/"; }
      { path = "/Applications/Bitwarden.app/"; }
      { path = "/System/Applications/Home.app/"; }
    ];
  };
}
