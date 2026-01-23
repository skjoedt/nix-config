{ pkgs, config, ... }:

{

  ".config/fabric/patterns/one-liner/system.md" = {
    text = builtins.readFile ./config/fabric/patterns/one-liner.md;
  };

}

