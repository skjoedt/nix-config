{ user, ... }:

{
  imports = [
    ../../modules/shared/home-manager.nix
    ../../modules/shared/packages/core-cli.nix
    ../../modules/shared/packages/cloud.nix
    ../../modules/shared/packages/dev.nix
    ../../modules/pc/packages.nix
    ../../modules/pc/files.nix
    ../../modules/pc/home-manager-programs.nix
    ../../modules/pc/home-manager-services.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    enableNixpkgsReleaseCheck = false;
    stateVersion = "25.11";
  };

  targets.genericLinux.enable = true;
}
