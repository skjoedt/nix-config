{ ... }:

let
  aerospaceConfig = builtins.fromTOML (builtins.readFile ./config/aerospace/config.toml);
in

{
  # macOS-specific programs

  programs.aerospace = {
    enable = true;
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
    };
  };
}
