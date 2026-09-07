{ user, ... }:

{
  imports = [
    ../../modules/shared/home-manager.nix
    ../../modules/shared/packages/core-cli.nix
    ../../modules/shared/packages/language-runtime.nix
    ../../modules/server/packages.nix
    ../../modules/server/files.nix
    ../../modules/server/home-manager-programs.nix
    ../../modules/server/home-manager-services.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    enableNixpkgsReleaseCheck = false;
    stateVersion = "25.11";
  };

  targets.genericLinux.enable = true;
}
