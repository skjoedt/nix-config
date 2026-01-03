{ user, config, pkgs, ... }:

{

  ".config/ghostty/themes/catppuccin-frappe" = {
    text = builtins.readFile ./config/ghostty/themes/catppuccin-frappe.conf;
  };
  ".warp/themes/catppuccin-frappe.yml" = {
    text = builtins.readFile ./config/warp/themes/catppuccin-frappe.yml;
  };
  ".config/amethyst/amethyst.yml" = {
    text = builtins.readFile ./config/amethyst/amethyst.yml;
  };

}
