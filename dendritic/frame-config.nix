{ config, inputs, ... }:
{
  configurations.nixos.frame.module = { lib, ... }: {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    
    system.stateVersion = "24.05";
    nixpkgs.hostPlatform = "x86_64-linux";
    
    boot.loader.systemd-boot.enable = lib.mkDefault true;
    networking.hostName = lib.mkDefault "frame";
    
    # Minimal filesystems for valid NixOS config (placeholder for actual hardware config)
    fileSystems."/" = lib.mkDefault {
      device = "nodev";
      fsType = "tmpfs";
    };
    
    services.openssh.enable = lib.mkDefault true;
    environment.systemPackages = [ ];
  };
}
