{
  pkgs,
  hostName,
  systemName,
  ...
}:
{
  # nix-darwin setup
  nixpkgs.hostPlatform = systemName;
  system.stateVersion = 6;
  networking.hostName = hostName;

  imports = [
    ../../users/root.nix
    ../../modules/nix_settings.nix
  ];

  environment.variables = {
    __ETC_ZSHRC_SOURCED = "1";
    __ETC_ZSHENV_SOURCED = "1";
  };

  # programs
  programs = {
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # users
  users = {
    users = {
      mika = {
        shell = pkgs.zsh;
      };
      root = {
        shell = pkgs.zsh;
      };
    };
  };

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
    kitty
  ];


  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew";

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
    ];

    brews = [
      "fzf"
      "ripgrep"
    ];

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.terminess-ttf
    terminus_font
  ];
}
