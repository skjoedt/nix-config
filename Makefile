# We need to do some OS switching below.
UNAME := $(shell uname)

switch:
ifeq ($(UNAME), Darwin)
	nix run .#switch-darwin
else
	nix run .#switch-pc
endif

test:
	nix flake check -L

build-pc:
	nix run .#build-pc

build-server:
	nix run .#build-server

switch-server:
	nix run .#switch-server

eval-darwin:
	nix run .#eval-darwin

fmt:
	nix fmt
