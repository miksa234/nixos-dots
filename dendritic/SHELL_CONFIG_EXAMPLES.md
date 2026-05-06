# Cross-Platform Shell Config Examples

This document shows how the `shell-config.nix` module can be used across different platforms while sharing the same configuration code.

## Module Contents

### Shared Components (Defined Once)
```nix
gitConfig = {
  user = { name = "Mika"; email = "mika@example.com"; };
  core = { editor = "nvim"; pager = "less -F"; };
  init = { defaultBranch = "main"; };
  pull = { rebase = true; };
  fetch = { prune = true; };
  diff = { tool = "nvim"; };
  merge = { conflictStyle = "zdiff3"; };
};

shellAliases = {
  ".." = "cd ..";
  "l" = "ls -lh";
  "ga" = "git add";
  "gst" = "git status";
  "gc" = "git commit";
};

shellEnvironment = {
  EDITOR = "nvim";
  PAGER = "less";
  LESS = "-F -X";
};
```

### Platform-Specific Application

#### NixOS Desktop (Linux)
```nix
# In /etc/nixos/configuration.nix or a module
{ imports = [ ../../dendritic/features.d/shell-config.nix ]; }

# Results in:
# - System-level git configuration
# - /etc/zsh/zshrc contains aliases
# - Environment variables set system-wide
# - Git, neovim, bat, ripgrep installed system-wide
```

#### Home-Manager on Linux
```nix
# In ~/.config/home-manager/home.nix
{ imports = [ ../dendritic/features.d/shell-config.nix ]; }

# Results in:
# - User git configuration (~/.gitconfig)
# - Shell aliases in ~/.zshrc (if using zsh)
# - Environment variables in ~/.profile
# - Packages installed to user profile
```

#### macOS (Darwin) via home-manager
```nix
# In ~/.config/home-manager/home.nix on macOS
{ imports = [ ../dendritic/features.d/shell-config.nix ]; }

# Results in:
# - User git configuration
# - Shell aliases and environment variables
# - Packages installed to user profile
# isDarwin detection ensures platform-specific settings apply
```

## Context Detection in Action

### How the Module Knows Which Context It's In

```nix
isHomeManager = config ? home;

# When imported by home-manager:
#   config contains: { home = { homeDirectory = "/home/user"; ... }; }
#   isHomeManager = true

# When imported by NixOS:
#   config contains: { system = ...; networking = ...; }
#   config does NOT have home attribute
#   isHomeManager = false

# When imported by nix-darwin:
#   config contains: { system = ...; environment = ...; }
#   config does NOT have home attribute
#   isHomeManager = false
```

## Configuration Sharing Benefits

### ✅ DRY (Don't Repeat Yourself)
- Git configuration defined once
- Shell aliases defined once
- Environment variables defined once

### ✅ Consistency
- Same git settings across all machines
- Same aliases work on desktop, server, and personal laptop
- Easy to update settings in one place

### ✅ Flexibility
- Can override settings per-context if needed
- Platform-specific extensions possible
- Add Darwin-only or Linux-only options easily

## Example: Adding Platform-Specific Settings

If you wanted to add macOS-specific settings:

```nix
(lib.mkIf (isDarwin && isHomeManager) {
  # macOS home-manager specific settings
  programs.zsh.envExtra = ''
    # macOS-specific environment setup
  '';
  
  programs.git.extraConfig = {
    credential.helper = "osxkeychain";
  };
})
```

## Example: Adding New Shared Aliases

To add new shell aliases available on all platforms:

1. Add to the `shellAliases` let-binding
2. Aliases automatically appear in:
   - `programs.zsh.shellAliases` (home-manager)
   - `programs.zsh.shellAliases` (NixOS)
   - System-wide on NixOS via shell configuration

```nix
shellAliases = {
  # ... existing aliases
  "new-alias" = "command";  # Added once
  # Automatically available on all platforms
};
```

## Testing the Module

### Verify syntax
```bash
nix-instantiate --parse dendritic/features.d/shell-config.nix
```

### Check flake evaluation
```bash
cd config.nix
nix flake check
```

### Test in home-manager preview
```bash
home-manager build -f dendritic/features.d/shell-config.nix
```

## Real-World Usage Scenario

Imagine maintaining config for:
- Desktop Linux (NixOS)
- Server (NixOS headless)
- Personal MacBook (macOS via home-manager)
- Staging environment (Linux via home-manager)

Without this pattern, you'd need 4 separate implementations of git config, shell aliases, and environment setup. With the pattern, you have ONE module that works across all four!

Changes to git config or shell aliases automatically propagate to all machines on next rebuild.

## See Also
- `dendritic/features.d/shell-config.nix` - The actual implementation
- `dendritic/CROSS_PLATFORM_PATTERN.md` - Detailed pattern documentation
- `dendritic/nixos.nix` - How NixOS configurations are structured
- `dendritic/darwin.nix` - How nix-darwin configurations are structured
- `dendritic/home-manager.nix` - How home-manager configurations are structured
