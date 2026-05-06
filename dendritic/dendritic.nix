{ inputs, ... }:
{
  imports = [
    # Enable flake-parts' modules system to support lower-level modules
    inputs.flake-parts.flakeModules.modules
  ];
}
