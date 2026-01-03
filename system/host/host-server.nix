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
    ];

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
      forwardPorts = [
        { from = "host"; host.port = 2222; guest.port = 61745; }
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
    ];
  };

  # netowrk
  networking = {
    hostName = "${hostName}";
    networkmanager.enable = true;
  };

  # time/locale
  i18n.defaultLocale = "en_US.UTF-8";

  # users
  users.users = {
    r2d2 = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "123";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjUjMsWMlPY0YNtSPMdmCIBnNHzT8PdN7Gc0a+RuQg2slRe7Gh1HgRPAX0pg3CIh0oNTDfuOGrOTcl/SdX+WdhChZJkcoKiDKPB98TCioJnYF9k1vouhx0P3soN/Bd4gQEd2Vx0+XTQzmK9VhFtBoNQt9Eh90ZGCrBtsfPB9odDuymotI9FPXSboUPAe3WttzzUeTpY3JurInHW2rCQsYIvti0ZGwdm6EwVjN+6aZ300uT6olrAc+6csyOZrdQQXm1G35x6MLKpYoyFoGQYkS/4vvHMbzj9F9zp8Y+aUZ0+iQvK2owhS7auzELuO2/nqwODCHXLxn8Sg15r0XJn4tVvgAxqvtG+i0SIeqjfrzsu+fg1n2tJGCAq96nyOCruYHcmLOQ0Z9d+hf04Y1thS4GCtNmqT/RGdboDI1xEmg3PaUUPgaL7pCiG+6OtTC/4F0/f/m6neRn219UAPshI7LZKT1aRsBCqKRnEmbUSKWa0ilDntCDsST2VcHwKk0Tjnb+UIvjoHJ2qQQao7i1dmzZ8oUu/9wpyt5aaNxxvcm6qfjht1TGw/1RBHyhOsPNrlHpzUtzbvDdVwHfO0/6eksb73kJ7WMqU+FutbF5ekogcUzkYMo6G7O6hDMFb+w405ontM5syg6OcYWTq2+kllbKiGETxQpizzuWKERCExpHWQ== mika@frame"
      ];
    };
    root = {
      shell = pkgs.zsh;
    };
  };
  security.sudo.wheelNeedsPassword = false;

  # services
  services = {
    fwupd.enable = true;
    automatic-timezoned.enable = true;
    openssh = {
      enable = true;
      ports = [ 61745 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  # programs
  programs = {
    zsh.enable = false;
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

  # packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    wget
    zsh
    git
    curl
    tree
    coreutils
    stdenv
    util-linux
    pstree
  ];

  # fonts
  fonts.packages = with pkgs; [
    terminus_font
  ];
}

