{ config, pkgs, lib, inputs,... }:

{

  ghostty = {
    enable = true;
    settings = {
      theme = "catppuccin-frappe";
      # Font
      "font-family" = "JetBrainsMono Nerd Font";
      "font-size" = 14;

      # Window
      "window-theme" = "ghostty";
      "window-padding-x" = 14;
      "window-padding-y" = 14;
      confirm-close-surface = false;
      "resize-overlay" = "never";
      "gtk-toolbar-style" = "flat";

      # Cursor
      "cursor-style" = "block";
      "cursor-style-blink" = false;

      # Shell integration features
      "shell-integration-features" = [ "no-cursor" "ssh-env" ];

      # Keybinds (kept the helpful Omarchy copy/paste ones)
      keybind = [
        "shift+insert=paste_from_clipboard"
        "control+insert=copy_to_clipboard"
      ];

      "async-backend" = "epoll";
    };

    themes = {
      "catppuccin-frappe" = {
        background = "303446";
        cursor-color = "f2d5cf";
        foreground = "c6d0f5";
        palette = [
          "0=#51576d"
          "1=#e78284"
          "2=#a6d189"
          "3=#e5c890"
          "4=#8caaee"
          "5=#f4b8e4"
          "6=#81c8be"
          "7=#a5adce"
          "8=#626880"
          "9=#e78284"
          "10=#a6d189"
          "11=#e5c890"
          "12=#8caaee"
          "13=#f4b8e4"
          "14=#81c8be"
          "15=#b5bfe2"
        ];
        "selection-background" = "44495d";
        "selection-foreground" = "c6d0f5";
      };
    };
  };

  # wayland = {
  #   windowManager.hyprland = {
  #     enable = true;
  #     package = null;
      
  #   };
  # };
}
