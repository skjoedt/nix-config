{ pkgs, ... }:

{
  home.packages = with pkgs; [
    direnv # Environment variable management per directory
    devenv
    gh # GitHub CLI
    nixfmt-rfc-style
    yamllint
  ];
}
