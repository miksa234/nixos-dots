# Cross-platform shell and developer tools configuration
# 
# This module demonstrates the dendritic pattern for sharing configurations
# across multiple platforms (NixOS, macOS via home-manager, and home-manager on Linux).
#
# Design Pattern:
# ===============
# The module uses runtime detection of the config context to apply platform-appropriate
# settings instead of relying on specialArgs. This allows the same module to be
# imported by both NixOS and home-manager configurations.
#
# Key techniques:
# 1. Platform detection: Check for home-manager context using `config ? home`
#    - If true: Running in home-manager context
#    - If false: Running in NixOS or nix-darwin context
#
# 2. Conditional imports: Use lib.optionalAttrs and lib.optionals to conditionally
#    apply settings based on the detected context
#
# 3. Shared configuration: Common settings (git config, aliases, environment variables)
#    are applied to both contexts
#
# 4. Platform-specific settings: Darwin-specific and Linux-specific options are
#    wrapped in conditional blocks
#
# Usage:
# ======
# This module can be imported by:
# 
# NixOS:
#   { imports = [ ./dendritic/features.d/shell-config.nix ]; }
#
# home-manager:
#   { imports = [ ./dendritic/features.d/shell-config.nix ]; }
#
# macOS (via home-manager):
#   { imports = [ ./dendritic/features.d/shell-config.nix ]; }

{
  config,
  pkgs,
  lib,
  isDarwin ? (builtins.currentSystem == "aarch64-darwin" || builtins.currentSystem == "x86_64-darwin"),
  ...
}:

let
  # Detect if this is running in a home-manager context
  # (home-manager adds a config.home attribute)
  isHomeManager = config ? home;

  # Common git configuration shared across all platforms
  gitConfig = {
    user = {
      name = "Mika";
      email = "mika@example.com";
    };
    core = {
      editor = "nvim";
      pager = "less -F";
    };
    init = {
      defaultBranch = "main";
    };
    pull = {
      rebase = true;
    };
    fetch = {
      prune = true;
    };
    diff = {
      tool = "nvim";
    };
    merge = {
      conflictStyle = "zdiff3";
    };
  };

  # Shell aliases that work across all platforms
  shellAliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "l" = "ls -lh";
    "la" = "ls -lah";
    "ll" = "ls -lh";

    # Git shortcuts
    "ga" = "git add";
    "gst" = "git status";
    "gc" = "git commit";
    "gd" = "git diff";
    "gp" = "git push";
    "gl" = "git log --oneline -10";
    "gb" = "git branch";
    "gco" = "git checkout";

    # Common utilities
    "cat" = "bat";
    "grep" = "rg";
    "diff" = "diff --color=auto";
  };

  # Environment variables common across all platforms
  shellEnvironment = {
    EDITOR = "nvim";
    PAGER = "less";
    LESS = "-F -X";
  };
in

# Apply different configurations based on context
lib.mkMerge [
  # === HOME-MANAGER CONTEXT ===
  (lib.mkIf isHomeManager {
    # Home-manager specific configuration
    programs.git = {
      enable = true;
      userName = gitConfig.user.name;
      userEmail = gitConfig.user.email;
      extraConfig = gitConfig.core // gitConfig.init // gitConfig.pull // gitConfig.fetch // gitConfig.diff // gitConfig.merge;
    };

    programs.zsh = lib.mkIf config.programs.zsh.enable {
      shellAliases = shellAliases;
      envExtra = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: value: "export ${name}=\"${value}\"") shellEnvironment
      );
    };

    programs.bash = lib.mkIf config.programs.bash.enable {
      shellAliases = shellAliases;
      bashrcExtra = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: value: "export ${name}=\"${value}\"") shellEnvironment
      );
    };

    # Environment variables available to all programs
    home.sessionVariables = shellEnvironment;

    # Ensure essential CLI tools are available
    home.packages = with pkgs; [
      git
      neovim
      bat
      ripgrep
      less
    ];
  })

  # === NIXOS/NIX-DARWIN CONTEXT ===
  (lib.mkIf (!isHomeManager) {
    # System-level git configuration
    programs.git = {
      enable = true;
      config = gitConfig;
    };

    # System-level environment
    environment.variables = shellEnvironment;

    # For NixOS systems with zsh shell
    programs.zsh = {
      enable = true;
      shellAliases = shellAliases;
    };

    # System packages
    environment.systemPackages = with pkgs; [
      git
      neovim
      bat
      ripgrep
      less
    ];
  })

  # === SHARED / CONDITIONAL PLATFORM-SPECIFIC CONFIG ===
  (lib.mkIf isDarwin
    # macOS-specific settings (can be applied in either context)
    {
      # Darwin-specific git options (via home-manager or nix-darwin)
    }
  )
]
