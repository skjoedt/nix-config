{ config, pkgs, lib, inputs, user, ... }:

{
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    enableNixpkgsReleaseCheck = false;

    packages = pkgs.callPackage ../../modules/pc/packages.nix {};

    file = import ../../modules/shared/files.nix { inherit config pkgs; };

    stateVersion = "25.11";
  };

  programs = lib.mkMerge [
    (import ../../modules/shared/home-manager-programs.nix { inherit config pkgs lib inputs; })
    (import ../../modules/pc/home-manager-programs.nix { inherit config pkgs lib inputs; })
  ];

  services = lib.mkMerge [
    (import ../../modules/shared/home-manager-services.nix { inherit config pkgs lib; })
    (import ../../modules/pc/home-manager-services.nix { inherit config pkgs lib; })
  ];

  manual.manpages.enable = false;
}
