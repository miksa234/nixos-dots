{
  pkgs,
  lib,
  hostName,
  inputs,
  isDarwin,
  ...
}:
{
  imports = [
    ../../users/root.nix
    ../../modules/nix-settings.nix
    ../../modules/nm.nix
  ];

  sops.defaultSopsFile = ../../secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/mika/.config/sops/age/keys.txt";

  system.stateVersion = "26.05";

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

  virtualisation.docker = {
    enable = true;
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
      "usbcore.autosuspend=-1"
      "pcie_port_pm=off"
      "acpi.no_ec_wakup=1"
    ];
    supportedFilesystems = [
      "btrfs"
      "ext4"
      "vfat"
      "ntfs"
    ];
  };

  # netowrk
  networking.hostName = "${hostName}";
  networking.wireless.enable = true;

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  # time/locale
  i18n.defaultLocale = "en_US.UTF-8";

  # programs
  programs = {
    nix-ld.enable = true;
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
        extraGroups = [
          "wheel"
          "docker"
        ];
        initialPassword = "123";
        shell = pkgs.zsh;
      };
      root = {
        shell = pkgs.zsh;
      };
    };
  };
  security.sudo.wheelNeedsPassword = false;

  powerManagement.powertop.enable = true;

  # services
  services = {
    automatic-timezoned.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    tlp.enable = false;
    power-profiles-daemon.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      serverFlagsSection = ''
        Option "Xauth" "$XAUTHORITY"
      '';
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
  }
  // lib.optionalAttrs (!isDarwin) {
    gnome.gnome-keyring.enable = true;
    security.pam.services.gdm.enableGnomeKeyring = true;
    libinput = {
      enable = true;
      touchpad.naturalScrolling = false;
    };
    openssh = {
      enable = false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "mika" ];
      };
    };
  };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "20m";
  };

  systemd.network.links."10-wlan0" = {
    matchConfig.MACAddress = "14:AC:60:29:82:AB";
    linkConfig.Name = "wlan0";
  };

  # hardware
  hardware.bluetooth.enable = true;
  hardware.sensor.iio.enable = false; # disable light sensors
  security.rtkit.enable = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
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
    gnome.gvfs
    ntfs3g

    upower
    lm_sensors
    acpilight
  ];

  # fonts
  fonts.packages = with pkgs; [
    nerd-fonts.terminess-ttf
    noto-fonts
    noto-fonts-color-emoji
    terminus_font
    liberation_ttf
    fira-code
    fira-code-symbols
    ubuntu-classic
    corefonts
  ];
  fonts.fontconfig.useEmbeddedBitmaps = true;
}
