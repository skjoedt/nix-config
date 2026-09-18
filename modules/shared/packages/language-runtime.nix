{ pkgs, ... }:

let
  myPython = pkgs.python3.withPackages (
    ps: with ps; [
      pip
      virtualenv
      requests
      pyyaml
    ]
  );
in
{
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    bun
    myPython # Custom Python with packages
    postgresql
    sqlite # SQL database engine
    uv
  ];
}
