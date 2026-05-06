{ config, inputs, ... }:
{
  configurations.nixos.frame.module = nixosArgs: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      inputs.sops-nix.nixosModules.sops
      ../hosts/frame/configuration.nix
      ../hosts/frame/hardware.nix
      # Skip root.nix for now to avoid complex dependencies
    ];
    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
