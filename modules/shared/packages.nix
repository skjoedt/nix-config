{ pkgs, ... }:
let
  myPython = pkgs.python3.withPackages (ps: with ps; [
    pip
    virtualenv
    requests
    pyyaml
  ]);

  myFonts = import ./fonts.nix { inherit pkgs; };
in
with pkgs; [
  # A
  atuin
  awscli
  
  # B
  bat # Cat clone with syntax highlighting
  btop # System monitor and process viewer

  # C
  carapace

  # D
  direnv # Environment variable management per directory
  devenv

  # E
  eza

  # F
  fzf # Fuzzy finder

  # G
  gh # GitHub CLI
  glow # Markdown renderer for terminal
  gnupg # GNU Privacy Guard

  # H
  htop # Interactive process viewer

  # I
  iftop # Network bandwidth monitor

  # J
  jq # JSON processor

  # K
  killall # Kill processes by name
  k9s
  kubectl
  kubernetes-helm
  kustomize
  k3d

  # L

  # M
  myPython # Custom Python with packages

  # N
  ncdu # Disk space utility
  nixfmt-rfc-style

  # O

  # P
  pandoc # Document converter

  # Q

  # R

  # S
  sqlite # SQL database engine

  # T
  terraform # Infrastructure as code tool
  terraform-ls # Terraform language server
  tflint # Terraform linter
  tmux # Terminal multiplexer
  tree # Directory tree viewer

  # U
  unrar # RAR archive extractor
  unzip # ZIP archive extractor

  # W
  wget # File downloader
  watch

  # Y
  yamllint

  # Z
  zip # ZIP archive creator
  zsh-powerlevel10k # Zsh theme
  zsh-fzf-tab
  zsh-forgit
  zsh-z
] ++ myFonts
