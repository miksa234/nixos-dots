{ ... }:
{
  dendritic.modules.nixos.host-server =
    { hostName, inputs, lib, pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      system.stateVersion = "25.11";

      networking.hostName = hostName;
      networking.firewall.enable = true;

      i18n.defaultLocale = "en_US.UTF-8";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-label/ESP";
        fsType = "vfat";
      };

      services.openssh.enable = true;

      security.sudo.wheelNeedsPassword = false;

      programs.zsh.enable = true;

      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      environment.systemPackages = with pkgs; [
        curl
        git
        htop
        neovim
        tree
        wget
      ];

      systemd.services.sshd.wantedBy = lib.mkDefault [ "multi-user.target" ];
    };
}
