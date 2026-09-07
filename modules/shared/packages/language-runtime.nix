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
  home.packages = with pkgs; [
    bun
    myPython # Custom Python with packages
    postgresql
    sqlite # SQL database engine
    uv
  ];
}
