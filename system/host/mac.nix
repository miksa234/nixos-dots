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
        AppleInterfaceStyleSwitchesAutomatically = true;
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        AppleMetricUnits = 1;
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
        tilesize = 50;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      # Remap §± to ~
      nonUS.remapTilde = true;
      userKeyMapping = [
        {
          HIDKeyboardModifierMappingSrc = 30064771172;
          HIDKeyboardModifierMappingDst = 30064771125;
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
      after-startup-command = [ ];
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      automatically-unhide-macos-hidden-apps = false;
      on-mode-changed = [ ];

      key-mapping = {
        preset = "qwerty";
      };

      gaps = {
        inner = {
          horizontal = 10;
          vertical = 10;
        };
        outer = {
          left = 10;
          bottom = 10;
          top = 10;
          right = 10;
        };
      };

      mode.main.binding = {
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        # Focus
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # Move
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        # Resize
        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";

        # Workspace
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";

        # Move node to workspace
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";


        alt-enter = "exec-and-forget open -n /Users/mika/Applications/kitty.app";
        alt-c = "exec-and-forget open -n /Users/mika/Applications/Firefox.app";
        alt-shift-w = "exec-and-forget open -n /Users/mika/Applications/Spotify.app";
        alt-shift-q = "close --quit-if-last-window";
        alt-m = "exec-and-forget /Users/mika/Applications/kitty.app/Contents/MacOS/kitty neomutt";
        alt-f = "fullscreen";


        # Workspace navigation
        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # Mode
        alt-shift-semicolon = "mode service";
      };

      mode.service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ];
        f = [ "layout floating tiling" "mode main" ];
        backspace = [ "close-all-windows-but-current" "mode main" ];
        alt-shift-h = [ "join-with left" "mode main" ];
        alt-shift-j = [ "join-with down" "mode main" ];
        alt-shift-k = [ "join-with up" "mode main" ];
        alt-shift-l = [ "join-with right" "mode main" ];
      };
    };
  };

  homebrew = {
    enable = true;
    user = "mika";
    prefix = "/opt/homebrew";
    taps = [ ];
    brews = [ ];
    casks = [ ];
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
