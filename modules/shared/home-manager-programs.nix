{ config, pkgs, lib, inputs, ... }:

let name = "Christian Skjødt";
    user = "skjoedt";
    email = "skjoedt@dev.local";
    
    nixpkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
    };
  in
{

  direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    mise.enable = true;
  };

  zsh = {
    enable = true;
    autocd = false;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = {
      k = "kubectl";
      v = "nvim";
      c = "opencode";
      ls = "eza -lh --group-directories-first --icons=auto";
      lt = "eza --tree --level=2 --long --icons --git";
      "?" = "opencode run --model github-copilot/gpt-5-mini 'respond in short'";
      "??" = "opencode run --model github-copilot/claude-sonnet-4.6";
    };
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

      autoload -Uz compinit
      compinit

            
      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"
      export HISTCONTROL=ignorespace

      export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
      zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
      source <(carapace _carapace)

      # Fix potential broken Homebrew completion symlinks
      # for completion in /opt/homebrew/share/zsh/site-functions/*; do
      #   [[ -f "$completion" && -x "$completion:A" ]] || compdef _default "${completion:t}"
      # done
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
      #search_mode = "daemon-fuzzy";
      search_mode = "fuzzy";
      #daemon.autostart = true;
      filter_mode = "host";
      workspaces = true;
      style = "compact";
      inline_height = 30;
      show_preview = true;
      show_help = false;
      show_tabs = false;
      records = true;
      history_filter = [
        "pwd"
      ];
    };
  };

  kubecolor = {
    enable = true;
    enableZshIntegration = true;
  };

  opencode = {
    enable = true;
  };

  gh = {
    enable = true;
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    lfs = {
      enable = true;
    };
    settings = {
      user = {
        name = name;
        email = email;
      };
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
      apply.whitespace = "fix";

      alias = {
        s = "status -s";
        l = "log --pretty=oneline -n 20 --graph --abbrev-commit";
        c = "clone --recursive";
        p = "pull --recurse-submodules";
        co = "checkout";
        ca = "!git add -A && git commit -av";
        amend = "commit --amend --reuse-message=HEAD";
        tags = "tag -l";
        br = "branch";
        remotes = "remote --verbose";
      };

      "color \"status\"" = { 
        added = "green";
        changed = "yellow";
        untracked = "red";
      };
    };
  };

  mise = {
    enable = true;
    enableZshIntegration = true;
  };

  neovim = {
    enable = true;
    package = nixpkgs-unstable.neovim-unwrapped;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # --- Core Plugins (Loaded immediately on launch) ---
      catppuccin-nvim
      nvim-treesitter.withAllGrammars
      blink-cmp

      # --- Optional Plugins (Lazy-loaded via vim.pack.add) ---
      {
        plugin = mini-nvim;
        optional = true;
      }
      {
        plugin = fzf-lua;
        optional = true;
      }
    ];

    # Nix manages all external binaries
    extraPackages = with pkgs; [
      nixd
      lua-language-server
      ripgrep
      fd
    ];

    extraLuaConfig = ''
      -- Core Options
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.clipboard = "unnamedplus"
      vim.opt.undofile = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true

      -- Apply Colorscheme
      vim.cmd.colorscheme("catppuccin")
    '';
  };


  ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
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
    enable = false;
    shell = "${pkgs.zsh}/bin/zsh";
    sensibleOnTop = false;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
      prefix-highlight
      catppuccin
    ];
    terminal = "screen-256color";
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = ''
      # Set prefix key to Ctrl-Space
      set -g prefix C-Space
      set -g prefix2 C-b
      bind C-Space send-prefix # double ctrl+space to send literal ctrl+space

      # Pane Controls
      bind h split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind x kill-pane

      bind -n C-M-Left select-pane -L   # Move focus to pane on the left
      bind -n C-M-Right select-pane -R  # Move focus to pane on the right
      bind -n C-M-Up select-pane -U     # Move focus to pane above
      bind -n C-M-Down select-pane -D   # Move focus to pane below

      # Window navigation
      bind r command-prompt -I "#W" "rename-window -- '%%'"
      bind c new-window -c "#{pane_current_path}"
      bind k kill-window

      bind -n M-1 select-window -t 1    # Navigate using Alt+number
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      bind -n M-Left select-window -t -1                 # Alt+Left switches to previous tmux window
      bind -n M-Right select-window -t +1                # Alt+Right switches to next tmux window
      bind -n M-S-Left swap-window -t -1 \; select-window -t -1   # Alt+Shift+Left swaps current window with previous, then moves focus there
      bind -n M-S-Right swap-window -t +1 \; select-window -t +1  # Alt+Shift+Right swaps current window with next, then moves focus there

      # Session controls
      bind R command-prompt -I "#S" "rename-session -- '%%'"
      bind C new-session -c "#{pane_current_path}"

      # General
      set -g default-terminal "tmux-256color"  # sets terminal type to tmux 256-color capable terminfo for better color support
      set -ag terminal-overrides ",*:RGB"      # enables truecolor (RGB) support for all terminals
      set -g mouse on                          # enables mouse support for pane selection, resizing, scrolling
      set -g base-index 1                      # sets window numbering to start at 1 instead of 0
      setw -g pane-base-index 1                # sets pane numbering to start at 1 instead of 0
      set -g renumber-windows on               # automatically renumbers windows when one is closed
      set -g history-limit 50000               # sets scrollback history size to 50000 lines
      set -g escape-time 0                     # removes delay for escape key sequences (faster key response)
      set -g focus-events on                   # enables focus in/out events from terminal (for apps that use focus tracking)
      set -g set-clipboard on                  # allows tmux to integrate with system clipboard
      set -g allow-passthrough on              # allows terminal escape sequences to pass through tmux (e.g. truecolor, advanced features)
      setw -g aggressive-resize on             # makes windows resize based on the smallest attached client
      set -g detach-on-destroy off             # prevents tmux from exiting/detaching session behavior when windows/sessions are destroyed
      set -g extended-keys on                  # enables support for extended key input sequences (modern key reporting)
      set -g extended-keys-format csi-u        # uses CSI u format for extended key encoding
      set -sg escape-time 10                   # sets server-level escape-time to 10ms (overrides earlier value, reintroduces small key delay)

      # Status bar
      set -g status-position top
      set -g status-interval 5
      set -g status-left-length 30
      set -g status-right-length 50
      set -g window-status-separator ""
      set -gw automatic-rename on
      set -gw automatic-rename-format '#{b:pane_current_path}'
            
      # Darwin-specific fix for tmux 3.5a with sensible plugin
      # This MUST be at the very end of the config
      set -g default-command "$SHELL"
      '';
    };
  # TODO: Some of the ALT bindings don't work on darwin

  eza = {
    enable = true;
    enableZshIntegration = true;
    theme = ''
      colourful: true

      filekinds:
        normal: {foreground: "#cdd6f4"}
        directory: {foreground: "#89b4fa"}
        symlink: {foreground: "#89b4fa"}
        pipe: {foreground: "#bac2de"}
        block_device: {foreground: "#eba0ac"}
        char_device: {foreground: "#eba0ac"}
        socket: {foreground: "#bac2de"}
        special: {foreground: "#cba6f7"}
        executable: {foreground: "#a6e3a1"}
        mount_point: {foreground: "#94e2d5"}

      perms:
        user_read: {foreground: "#f38ba8", is_bold: true}
        user_write: {foreground: "#f9e2af", is_bold: true}
        user_execute_file: {foreground: "#a6e3a1", is_bold: true}
        user_execute_other: {foreground: "#a6e3a1", is_bold: true}
        group_read: {foreground: "#f38ba8"}
        group_write: {foreground: "#f9e2af"}
        group_execute: {foreground: "#a6e3a1"}
        other_read: {foreground: "#f38ba8"}
        other_write: {foreground: "#f9e2af"}
        other_execute: {foreground: "#a6e3a1"}
        special_user_file: {foreground: "#cba6f7"}
        special_other: {foreground: "#7f849c"}
        attribute: {foreground: "#9399b2"}

      size:
        major: {foreground: "#a6adc8"}
        minor: {foreground: "#89dceb"}
        number_byte: {foreground: "#bac2de"}
        number_kilo: {foreground: "#a6adc8"}
        number_mega: {foreground: "#89b4fa"}
        number_giga: {foreground: "#cba6f7"}
        number_huge: {foreground: "#cba6f7"}
        unit_byte: {foreground: "#a6adc8"}
        unit_kilo: {foreground: "#89dceb"}
        unit_mega: {foreground: "#cba6f7"}
        unit_giga: {foreground: "#cba6f7"}
        unit_huge: {foreground: "#94e2d5"}

      users:
        user_you: {foreground: "#cdd6f4"}
        user_root: {foreground: "#f38ba8"}
        user_other: {foreground: "#eba0ac"}
        group_yours: {foreground: "#a6adc8"}
        group_other: {foreground: "#9399b2"}
        group_root: {foreground: "#f38ba8"}

      links:
        normal: {foreground: "#89b4fa"}
        multi_link_file: {foreground: "#89b4fa"}

      git:
        new: {foreground: "#a6e3a1"}
        modified: {foreground: "#f9e2af"}
        deleted: {foreground: "#eba0ac"}
        renamed: {foreground: "#94e2d5"}
        typechange: {foreground: "#f5c2e7"}
        ignored: {foreground: "#7f849c"}
        conflicted: {foreground: "#fab387"}

      git_repo:
        branch_main: {foreground: "#a6adc8"}
        branch_other: {foreground: "#cba6f7"}
        git_clean: {foreground: "#a6e3a1"}
        git_dirty: {foreground: "#eba0ac"}

      security_context:
        colon: {foreground: "#6c7086"}
        user: {foreground: "#7f849c"}
        role: {foreground: "#cba6f7"}
        typ: {foreground: "#585b70"}
        range: {foreground: "#cba6f7"}

      file_type:
        image: {foreground: "#f9e2af"}
        video: {foreground: "#f38ba8"}
        music: {foreground: "#a6e3a1"}
        lossless: {foreground: "#94e2d5"}
        crypto: {foreground: "#7f849c"}
        document: {foreground: "#cdd6f4"}
        compressed: {foreground: "#f5c2e7"}
        temp: {foreground: "#eba0ac"}
        compiled: {foreground: "#74c7ec"}
        source: {foreground: "#89b4fa"}

      punctuation: {foreground: "#6c7086"}
      date: {foreground: "#f9e2af"}
      inode: {foreground: "#a6adc8"}
      blocks: {foreground: "#6c7086"}
      header: {foreground: "#cdd6f4"}
      octal: {foreground: "#94e2d5"}
      flags: {foreground: "#cba6f7"}

      symlink_path: {foreground: "#89dceb"}
      control_char: {foreground: "#74c7ec"}
      broken_symlink: {foreground: "#f38ba8"}
      broken_path_overlay: {foreground: "#585b70"}
    '';
  };
  # TODO: Move theme elsewhere
}
