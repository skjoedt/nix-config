{ pkgs, inputs, ... }:

let
  aerospaceConfig = builtins.fromTOML (builtins.readFile ./config/aerospace/config.toml);
  nixpkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in

{
  # macOS-specific programs

  programs.aerospace = {
    enable = true;
    package = nixpkgs-unstable.aerospace;
    launchd.enable = true;
    userSettings = aerospaceConfig;
  };

  programs.ghostty = {
    enable = true;
    package = null; # not supported for darwin, but we do want to manage config
    settings = {
      theme = "catppuccin-frappe";
      font-size = 14;
      window-padding-x = 2;
      quit-after-last-window-closed = true;
    };
  };
}
