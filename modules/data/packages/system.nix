{ ... }:
{
  dendritic.data.packageSetSystem =
    { pkgs, ... }:
    with pkgs;
    {
      system = [
        home-manager
        nix
        just
        htop
        sops
        direnv
      ];

      shell = [
        zsh
        zsh-fast-syntax-highlighting
        zsh-system-clipboard
        tmux
        neovim
      ];

      cli = [
        (pass.withExtensions (exts: [ exts.pass-otp ]))
        ripgrep
        fzf
        wget
        curl
        tree
        fd
        zip
        unzip
        bzip2
        killall
        zbar
        pstree
        bat
        gptfdisk
        qrencode
        jq
        lazygit
      ];
    };
}
