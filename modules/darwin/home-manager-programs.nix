{ config, pkgs, lib, ... }:

{
  # macOS-specific programs

  ghostty = {
      enable = true;
      package = null; # not supported for darwin, but we do want to manage config
      settings = {
        theme = "catppuccin-frappe";
        font-size = 14;
        window-padding-x = 2;
        shell = "${pkgs.zsh}/bin/zsh";
      };
    };
}