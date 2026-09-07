{ ... }:

{
  imports = [
    ./files.nix
    ./home-manager-programs.nix
    ./home-manager-services.nix
  ];

  manual.manpages.enable = false;
}
