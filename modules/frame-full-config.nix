{ lib, pkgs, inputs, ... }:
{
  imports = [
    ./frame-hardware.nix
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  system.stateVersion = "26.05";

  sops.defaultSopsFile = ../secrets.yaml;
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

  networking.hostName = "frame";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.mika = {
    isNormalUser = true;
    description = "Mika";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "libvirtd" ];
    shell = pkgs.zsh;
  };
  users.users.root = {
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;
  security.pam.services.sddm.enableGnomeKeyring = true;

  powerManagement.powertop.enable = true;

  services = {
    automatic-timezoned.enable = false;
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
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
      displayManager.startx.enable = true;
    };
    getty.autologinUser = "mika";
    logind.settings.Login = {
      SleepOperation = "suspend-then-hibernate";
      HandlePowerKey = "suspend-then-hibernate";
      HandleLidSwitch = "suspend-then-hibernate";
      HandlePowerKeyLongPress = "poweroff";
    };
    gnome.gnome-keyring.enable = true;
  };

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = false;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    permittedInsecurePackages = [
      "segger-jlink-qt4-772o"
    ];
  };

  # Programs
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim git wget htop
    git-crypt gnupg pass
    coreutils util-linux
    nix curl tree
    stdenv
    dbus-broker pciutils pstree wireguard-tools
    gnome.gvfs ntfs3g
    upower lm_sensors acpilight
    ripgrep fd bat
    alacritty
    firefox
    git
  ];

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.max-jobs = lib.mkDefault 4;
}
