{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    betterfox.url =  "github:HeitorAugustoLN/betterfox-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    disko,
    home-manager,
    nixos-hardware,
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
          disko.nixosModules.disko
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
          ./system/host/host-frame.nix
          ./system/disk/disk-vm.nix
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
