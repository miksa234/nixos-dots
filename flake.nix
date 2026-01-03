{
  description = "NixOS";

  inputs = {
    nixpkgs_stable.url = "nixpkgs/nixos-25.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    betterfox.url =  "github:HeitorAugustoLN/betterfox-nix";
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
    disko,
    home-manager,
    nixos-hardware,
    sops-nix,
    betterfox,
    ...
    } @inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      nixos-frame = let
        hostName = "nixos-frame";
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit hostName;
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
                inherit system;
                inherit inputs;
                standalone = false;
              };
              users.mika = import ./users/mika.nix;
            };
          }
        ];
      };
      nixos-vm = let
        hostName = "nixos-vm";
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit hostName;
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
                inherit system;
                inherit inputs;
                standalone = false;
              };
              users.mika = import ./users/mika.nix;
            };
          }
        ];
      };
      nixos-server = let
        hostName = "nixos-server";
      in nixpkgs_stable.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit hostName;
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
                inherit system;
                inherit inputs;
                standalone = false;
              };
              users.r2d2 = import ./users/r2d2.nix;
            };
          }
        ];
      };
    };
    homeConfigurations = {
      mika = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./users/mika.nix ];
        extraSpecialArgs = {
          inherit system;
          inherit inputs;
          standalone = true;
        };
      };
    };

  };
}
