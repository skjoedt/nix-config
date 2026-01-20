{
  description = "My Nix Configuration for macOS and NixOS";

  inputs = {
    # Primary nixpkgs repository
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Use the unstable nixpkgs repo for some packages
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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

  };

outputs = { self, nixpkgs, home-manager, darwin, nix-homebrew, ... } @ inputs: let
    inherit (self) outputs;
    user = "skjoedt";
    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];    
    forAllSystems = nixpkgs.lib.genAttrs systems;  
  in {

    # Darwin configuration endpoint
    # Available through 'darwin-rebuild switch --impure --flake .#your-hostname'
    darwinConfigurations = {
      darwin-m1 = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = inputs // { inherit user; };
        modules = [
          { # temp fix for https://github.com/nixos/nixpkgs/issues/476794
            nixpkgs.overlays = [
              (final: prev: {
                nix = prev.nix.overrideAttrs (oldAttrs: {
                  doCheck = false;
                });
              })
            ];
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

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      vm_x86 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // { inherit user; };
        modules = [
          home-manager.nixosModules.home-manager {
            home-manager = {
              sharedModules = []; 
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = { config, pkgs, lib, ... }:
              import ./modules/nixos/home-manager.nix { inherit config pkgs lib inputs; };
            };
          }
          ./hosts/nixos
        ];
      };
    };
  };
}