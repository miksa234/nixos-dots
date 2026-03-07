{
  pkgs,
  hostName,
  system,
  ...
} :
{
  pkgs.hostPlatform = system;

  imports = [
    ../../users/root.nix
    ../../modules/nix_settings.nix
  ]

  environment.variables = {
    __ETC_ZSHRC_SOURCED = "1";
    __ETC_ZSHENV_SOURCED = "1";
  };

  # programs
  programs = {
    zsh.enable = true;
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
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
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.terminess-ttf
    terminus_font
  ];
}
