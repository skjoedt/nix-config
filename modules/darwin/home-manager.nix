{ config, pkgs, lib, home-manager, ... }:

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
    name     = "${user}";
    home     = "/Users/${user}";
    isHidden = false;
    shell    = pkgs.zsh;
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
    casks  = pkgs.callPackage ./casks.nix {};
    #masApps = {
    #  "hidden-bar"   = 1452453066;
    #  "wireguard"    = 1451685025;
    #};
  };

  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:
      {
        home = {
          enableNixpkgsReleaseCheck = false;
          # Add wallpaperScript to packages
          packages = (pkgs.callPackage ./packages.nix {}) ++ [ wallpaperScript ];

          # Add activation script to set the wallpaper
          activation = {
            setWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
              $DRY_RUN_CMD ${wallpaperScript}/bin/set-wallpaper-script
            '';
          };
          file = lib.mkMerge [
            (import ../shared/files.nix { inherit config pkgs; })
            (import ./files.nix { inherit user config pkgs; })
          ];
          stateVersion = "25.11";
        };
        programs = lib.mkMerge [
          (import ../shared/home-manager-programs.nix { inherit config pkgs lib; })
          (import ./home-manager-programs.nix { inherit config pkgs lib; })
        ];

        services = lib.mkMerge [
          (import ../shared/home-manager-services.nix { inherit config pkgs lib; })
          (import ./home-manager-services.nix { inherit config pkgs lib; })
        ];

        manual.manpages.enable = false;
      };
  };

  # Fully declarative dock using the latest from Nix Stor
  local.dock = {
    enable   = true;
    username = user;
    entries  = [
      { path = "/Applications/Google Chrome.app/"; }
      { path = "/Applications/Apps.app/"; }
      { path = "/Applications/Ghostty.app/"; }
      { path = "/Applications/Discord.app/"; }
      { path = "/Applications/Bitwarden.app/"; }
      { path = "/System/Applications/Home.app/"; }
    ];
  };
}

