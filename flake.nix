{
  description = "NixOS";
  inputs = {
    nixpkgs_stable.url = "nixpkgs/nixos-25.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    betterfox.url = "github:HeitorAugustoLN/betterfox-nix";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs_stable,
    nixpkgs,
    nix-darwin,
    disko,
    home-manager,
    nixos-hardware,
    sops-nix,
    betterfox,
    ...
  } @ inputs:
  let
    linuxSystem  = "x86_64-linux";
    darwinSystem = "aarch64-darwin";

    pkgsLinux    = nixpkgs.legacyPackages.${linuxSystem};
    pkgsDarwin   = nixpkgs.legacyPackages.${darwinSystem};
  in {
    nixosConfigurations =
    let
      isDarwin = false;
    in
    {
      nixos-frame =
        let
          hostName = "nixos-frame";
          system   = linuxSystem;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostName system isDarwin;
          };
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            ./system/host/host-frame.nix
            ./system/hardware/hardware-frame.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit system inputs isDarwin;
                  standalone = false;
                };
                users.mika = import ./users/mika.nix;
              };
            }
          ];
        };

      nixos-vm =
        let
          hostName = "nixos-vm";
          system   = linuxSystem;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostName system isDarwin;
          };
          modules = [
            home-manager.nixosModules.home-manager
            ./system/host/host-frame.nix
            ./system/hardware/hardware-vm.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit system inputs isDarwin;
                  standalone = false;
                };
                users.mika = import ./users/mika.nix;
              };
            }
          ];
        };

      nixos-server =
        let
          hostName = "nixos-server";
          system   = linuxSystem;
        in
        nixpkgs_stable.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostName system;
          };
          modules = [
            home-manager.nixosModules.home-manager
            ./system/host/host-server.nix
            ./system/hardware/hardware-vm.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit system inputs;
                  standalone = false;
                };
                users.r2d2 = import ./users/r2d2.nix;
              };
            }
          ];
        };
    };

    darwinConfigurations = {
      mac =
        let
          hostName = "mac";
          systemName   = darwinSystem;
          system = darwinSystem;
          isDarwin = true;
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit hostName systemName inputs isDarwin;
          };
          modules = [
            home-manager.darwinModules.home-manager
            sops-nix.darwinModules.sops
            ./system/host/mac.nix
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit system inputs isDarwin;
                  standalone = false;
                };
                users.mika = import ./users/mika.nix;
              };
            }
          ];
        };
    };

    homeConfigurations = {
      mika =
        let
          system = builtins.currentSystem;
          pkgs =
            if system == darwinSystem
            then pkgsDarwin
            else pkgsLinux;
          isDarwin = system == darwinSystem;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/mika.nix ];
          extraSpecialArgs = {
            inherit system inputs isDarwin;
            standalone = true;
          };
        };
    };
  };
}
