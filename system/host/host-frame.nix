{
  pkgs,
  hostName,
  ...
} :
{
  imports =
    [
      ../../users/root.nix
      ../../modules/nix_settings.nix
      ../../modules/nm.nix
    ];

  sops.defaultSopsFile = ../../secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/mika/.config/sops/age/keys.txt";

  system.stateVersion = "25.11";

  # vm
  virtualisation.vmVariant = {
    virtualisation = {
      diskSize = 50 * 1028; # 50 GB
      memorySize = 16 * 1028; # 16 GB
      cores = 6;
      resolution = {
        x = 1600;
        y = 900;
      };
      qemu.options = [
        "-enable-kvm"
        "-cpu host"
        "-display gtk,zoom-to-fit=false"
        "-vga virtio"
      ];
    };
  };

  # boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "loglevel=3"
      "nowatchdog"
      "migrations=auto"
      "amd_iommu=on"
      "iommu=pt"
      "rtc_cmos.use_acpi_alarm=1"
    ];
    initrd.services.udev.rules = ''
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="9A:C7:16:D6:89:36", NAME="wlan0"
    '';
  };

  # netowrk
  networking.hostName = "${hostName}";
  networking.wireless.iwd.enable = true;

  # time/locale
  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";

  # programs
  programs = {
    zsh.enable = true;
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment.variables = {
    __ETC_ZSHRC_SOURCED = "1";
    __ETC_ZSHENV_SOURCED = "1";
  };

  # users
  users = {
    users = {
      mika = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        initialPassword = "123";
        shell = pkgs.zsh;
      };
      root = {
        shell = pkgs.zsh;
      };
    };
  };
  security.sudo.wheelNeedsPassword = false;

  # services
  services = {
    upower.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    power-profiles-daemon.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    xserver = {
      enable = true;
      displayManager.startx = {
          enable = true;
      };
    };

    getty.autologinUser = "mika";

    logind.settings.Login = {
      SleepOperation = "suspend-then-hibernate";
      HandlePowerKey = "suspend-then-hibernate";
      HandleLidSwitch = "suspend-then-hibernate";
      HandlePowerKeyLongPress = "poweroff";
    };

  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=20m
  '';

  # hardware
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;

  # packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    nix
    curl
    tree
    coreutils
    stdenv
    dbus-broker
    pciutils
    util-linux
    pstree
    wireguard-tools

    upower
    lm_sensors
    acpilight
  ];


  # fonts
  fonts.packages = with pkgs; [
    terminus_font
  ];
}

