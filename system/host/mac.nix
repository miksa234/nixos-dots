{
  lib,
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
        home = "/Users/mika";
      };
      root = {
        shell = pkgs.zsh;
        home = "/var/root";
      };
    };
  };

  system = {
    primaryUser = "mika";
    defaults = {
      controlcenter = {
        BatteryShowPercentage = true;
        NowPlaying = false;
      };
      CustomUserPreferences = {
        "com.apple.symbolichotkeys" = {
          "64" = {
            # Disable 'Cmd + Space' for Spotlight Search
            enabled = false;
          };
          "65" = {
            # Disable 'Cmd + Alt + Space' for Finder search window
            enabled = false;
          };
          "238" = {
            # Set 'Control + Command + C' to center focused window
            enabled = true;
            value = {
              parameters = [
                99
                8
                1310720
              ];
              type = "standard";
            };
          };
          "98" = {
            # Disable 'Show Help menu'
            enabled = false;
            value = {
              parameters = [
                47
                44
                1179648
              ];
              type = "standard";
            };
          };
        };
      };
      NSGlobalDomain = {
        "com.apple.sound.beep.volume" = 0.000;
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 20;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        PMPrintingExpandedStateForPrint = true;
      };
      trackpad = {
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        Clicking = true;
      };
      finder = {
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
      dock = {
        autohide = true;
        expose-animation-duration = 0.15;
        show-recents = false;
        showhidden = true;
        persistent-apps = [ ];
        tilesize = 30;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      # Remap §± to ~
      userKeyMapping = [
        {
          HIDKeyboardModifierMappingDst = 30064771125;
          HIDKeyboardModifierMappingSrc = 30064771172;
        }
      ];
    };
  };

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
    pciutils
    util-linux
    pstree
    wireguard-tools
  ];

  services.aerospace = {
    enable = true;
    settings = {
      gaps.inner.horizontal = 10;
    };
  };


  homebrew = {
    enable = true;
    prefix = "/opt/homebrew";
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
