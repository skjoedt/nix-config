{ pkgs, ... }:

let
  myFonts = import ../fonts.nix { inherit pkgs; };
in
{
  home.packages =
    (with pkgs; [
      bat # Cat clone with syntax highlighting
      btop # System monitor and process viewer
      carapace # Command argument completion generator
      dig # DNS lookup utility
      doggo # DNS client
      eza
      fzf # Fuzzy finder
      glow # Markdown renderer for terminal
      gnupg # GNU Privacy Guard
      htop # Interactive process viewer
      iftop # Network bandwidth monitor
      jq # JSON processor
      killall # Kill processes by name
      ncdu # Disk space utility
      pandoc # Document converter
      tmux # Terminal multiplexer
      tree # Directory tree viewer
      unrar # RAR archive extractor
      unzip # ZIP archive extractor
      wget # File downloader
      watch
      wakeonlan
      zip # ZIP archive creator
      zsh-powerlevel10k # Zsh theme
      zsh-fzf-tab
      zsh-forgit
      zsh-z
    ])
    ++ myFonts;
}
