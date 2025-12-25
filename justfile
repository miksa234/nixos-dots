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

vm:
	sudo nix --experimental-features "nix-command flakes" run nixpkgs#nixos-rebuild --  build-vm --flake .#nixos-vm

clean:
	rm -r ./result
	rm *qcow2
