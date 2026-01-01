hostname := `hostname`
user := `whoami`

os:
    sudo nixos-rebuild switch --flake ./#{{hostname}} --impure

hm:
    home-manager switch -b backup --flake ./#{{user}}

gc:
    sudo nix-collect-garbage --delete-older-than 7d
    nix-collect-garbage --delete-older-than 7d

ls-nixos-packages:
    @nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq

ls-hm-packages:
    @home-manager packages | sort | uniq

vm machine:
	sudo nix --experimental-features "nix-command flakes" run nixpkgs#nixos-rebuild --  build-vm --flake .#{{machine}} --impure

anywhere machine target:
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hardware-configuration.nix --flake ./#{{machine}} --target-host {{target}}

clean:
	rm -r ./result
	rm *qcow2
