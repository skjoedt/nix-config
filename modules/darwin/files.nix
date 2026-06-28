{ ... }:

{
  home.file = {
    ".config/ghostty/themes/catppuccin-frappe" = {
      text = builtins.readFile ./config/ghostty/themes/catppuccin-frappe.conf;
    };
    ".hammerspoon/init.lua" = {
      text = builtins.readFile ./config/hammerspoon/init.lua;
    };
    # ".config/amethyst/amethyst.yml" = {
    #   text = builtins.readFile ./config/amethyst/amethyst.yml;
    # };
  };
}
