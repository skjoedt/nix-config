{ pkgs, ... }:

{
  home.packages =
    (with pkgs; [
      mkcert # Create locally-trusted development certificates
    ]);
}
