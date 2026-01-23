{ user, config, pkgs, ... }:

{

  ".config/ghostty/themes/catppuccin-frappe" = {
    text = builtins.readFile ./config/ghostty/themes/catppuccin-frappe.conf;
  };
  ".config/amethyst/amethyst.yml" = {
    text = builtins.readFile ./config/amethyst/amethyst.yml;
  };

}
