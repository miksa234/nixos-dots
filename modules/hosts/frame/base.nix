{ ... }:
{
  dendritic.modules.nixos.host-frame-base =
    {
      hostName,
      inputs,
      systemName,
      isWayland,
      dendritic,
      lib,
      ...
    }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager
        inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      ];

      system.stateVersion = "26.05";

      sops.defaultSopsFile = ../../../secrets.yaml;
      sops.defaultSopsFormat = "yaml";
      sops.age.keyFile = "/home/mika/.config/sops/age/keys.txt";

      virtualisation.vmVariant = {
        virtualisation = {
          diskSize = 50 * 1028;
          memorySize = 16 * 1028;
          cores = 6;
          resolution = { x = 1600; y = 900; };
          qemu.options = [
            "-enable-kvm"
            "-cpu host"
            "-display gtk,zoom-to-fit=false"
            "-vga virtio"
          ];
        };
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.timeout = 10;

      networking.hostName = hostName;
      networking.firewall.enable = true;

      i18n.defaultLocale = "en_US.UTF-8";

      security.sudo.wheelNeedsPassword = false;
      security.pam.services.sddm.enableGnomeKeyring = true;

      powerManagement.powertop.enable = true;

      nixpkgs.config = {
        allowUnfree = true;
        allowBroken = true;
        permittedInsecurePackages = [
          "segger-jlink-qt4-772o"
        ];
      };

      programs.zsh.enable = true;

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.settings.max-jobs = lib.mkDefault 4;

      home-manager.extraSpecialArgs = {
        inherit
          dendritic
          hostName
          inputs
          isWayland
          systemName
          ;
        isDarwin = false;
        isSystemManagedHome = true;
      };
    };
}
