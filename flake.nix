{
  description = "My Nix Configuration for macOS and Linux";

  inputs = {
    # Primary nixpkgs repository
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Use the unstable nixpkgs repo for some packages
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      nix-homebrew,
      ...
    }@inputs:
    let
      user = "skjoedt";
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowBroken = true;
            allowInsecure = false;
            allowUnsupportedSystem = true;
          };
          overlays = import ./overlays { inherit inputs; };
        };
      mkApp =
        pkgs: name: text:
        let
          package = pkgs.writeShellApplication {
            inherit name text;
            runtimeInputs = [ pkgs.nix ];
          };
        in
        {
          type = "app";
          program = "${package}/bin/${name}";
          meta.description = "Run the ${name} helper";
        };
      linuxApps =
        system:
        let
          pkgs = mkPkgs system;
        in
        {
          build-pc = mkApp pkgs "build-pc" ''
            nix build --impure '.#homeConfigurations."skjoedt@pc".activationPackage' -L
          '';
          switch-pc = mkApp pkgs "switch-pc" ''
            nix build --impure '.#homeConfigurations."skjoedt@pc".activationPackage' -L
            ./result/activate
          '';
          build-server = mkApp pkgs "build-server" ''
            nix build --impure '.#homeConfigurations."skjoedt@server".activationPackage' -L
          '';
          switch-server = mkApp pkgs "switch-server" ''
            nix build --impure '.#homeConfigurations."skjoedt@server".activationPackage' -L
            ./result/activate
          '';
          eval-darwin = mkApp pkgs "eval-darwin" ''
            nix eval --impure '.#darwinConfigurations.darwin-m1.config.system.build.toplevel.drvPath'
          '';
          fmt = mkApp pkgs "fmt" ''
            nix fmt .
          '';
        };
      darwinApps =
        system:
        let
          pkgs = mkPkgs system;
        in
        {
          switch-darwin = mkApp pkgs "switch-darwin" ''
            darwin_rebuild="$(command -v darwin-rebuild)"
            sudo "$darwin_rebuild" switch --impure --flake .#darwin-m1
          '';
          eval-darwin = mkApp pkgs "eval-darwin" ''
            nix eval --impure '.#darwinConfigurations.darwin-m1.config.system.build.toplevel.drvPath'
          '';
          fmt = mkApp pkgs "fmt" ''
            nix fmt .
          '';
        };
    in
    {

      # Darwin configuration endpoint
      # Available through 'sudo darwin-rebuild switch --impure --flake .#your-hostname'
      darwinConfigurations = {
        darwin-m1 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs user; };
          modules = [
            {
              nixpkgs.overlays = import ./overlays { inherit inputs; };
            }
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = inputs.homebrew-core;
                  "homebrew/homebrew-cask" = inputs.homebrew-cask;
                  "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/darwin
          ];
        };
      };

      # Standalone home-manager configurations
      # Available through 'home-manager switch --flake .#<name>'
      homeConfigurations = {
        "skjoedt@pc" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          extraSpecialArgs = { inherit inputs user; };
          modules = [
            ./hosts/pc
            ./modules/shared/default.nix
          ];
        };

        "skjoedt@server" = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          extraSpecialArgs = { inherit inputs user; };
          modules = [
            ./hosts/server
            ./modules/shared/default.nix
          ];
        };
      };

      formatter = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
        in
        pkgs.writeShellApplication {
          name = "nixfmt-wrapper";
          text = ''
            if [ "$#" -eq 0 ]; then
              exec ${pkgs.nixfmt-rfc-style}/bin/nixfmt .
            fi

            exec ${pkgs.nixfmt-rfc-style}/bin/nixfmt "$@"
          '';
        }
      );

      checks.x86_64-linux = {
        pc-activation = self.homeConfigurations."skjoedt@pc".activationPackage;
        server-activation = self.homeConfigurations."skjoedt@server".activationPackage;
      };

      apps =
        (nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] linuxApps)
        // (nixpkgs.lib.genAttrs [
          "aarch64-darwin"
          "x86_64-darwin"
        ] darwinApps);
    };
}
