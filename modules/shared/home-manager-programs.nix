{ config, pkgs, lib, ... }:

let name = "Christian Skjødt";
    user = "skjoedt";
    email = "skjoedt@dev.local"; in
{

  direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

  zsh = {
    enable = true;
    autocd = false;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "forgit";
        src = "${pkgs.zsh-forgit}/share/zsh/zsh-forgit";
      }
      {
        name = "zsh-z";
        src = "${pkgs.zsh-z}/share/zsh-z";
      }
    ];
    initContent = lib.mkBefore ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      export TERM=xterm-256color

            
      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"
      export HISTCONTROL=ignorespace

      export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
      zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
      source <(carapace _carapace)
    '';
  };

  atuin = {
    enable = true;
    enableZshIntegration = true;
    daemon.enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      search_mode = "prefix";
    };
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
	    editor = "vim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes vim-tmux-navigator ];
    settings = { ignorecase = true; };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      " Don't use clipboard=unnamedplus, use macOS pbcopy/pbpaste instead

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      '';
     };

  ssh = {
    enable = true;
    matchBlocks = {
      #"github.com" = {
      #  identitiesOnly = true;
      #  identityFile = [
      #    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
      #      "/home/${user}/.ssh/id_github"
      #    )
      #    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
      #      "/Users/${user}/.ssh/id_github"
      #    )
      #  ];
      #};
    };
  };

  fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      bg = "#303446";
      "bg+" = "#414559";
      fg = "#C6D0F5";
      "fg+" = "#C6D0F5";
      hl = "#E78284";
      spinner = "#F2D5CF";
      header = "#E78284";
      info = "#CA9EE6";
      pointer = "#F2D5CF";
      marker = "#BABBF1";
      prompt = "#CA9EE6";
      selected-bg = "#51576D";
      border = "#737994";
      label = "#C6D0F5";
    };
  };

  tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    sensibleOnTop = false;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
      prefix-highlight
    ];
    terminal = "screen-256color";
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = ''
      # Remove Vim mode delays
      set -g focus-events on

      # Enable full mouse support
      set -g mouse on

      # Darwin-specific fix for tmux 3.5a with sensible plugin
      # This MUST be at the very end of the config
      set -g default-command "$SHELL"
      '';
    };

  eza = {
    enable = true;
    enableZshIntegration = true;
    # TODO: add catpuccino theme 
  };
}
