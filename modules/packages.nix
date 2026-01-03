{ pkgs }:
let
  fetchSucklessRepo = repo: hash: pkgs.fetchgit {
    url = "git://popovic.xyz/${repo}.git";
    inherit hash;
  };

  suckless = with pkgs; {
    dwm = dwm.overrideAttrs (old: {
      src = fetchSucklessRepo "dwm" "sha256-wG5rs6XnRqsTCmEjPOO4hnrbvnDFVFmZexCwmUu/2ZQ=";
      buildInputs = old.buildInputs ++ [ xorg.libxcb ];
    });

    st = st.overrideAttrs (old: {
      src = fetchSucklessRepo "st" "sha256-7vQRrfH8QFIgbD8Grcw2hXBezCboraYUXdMv8CbkK00=";
    });

    dmenu = dmenu.overrideAttrs (old: {
      src = fetchSucklessRepo "dmenu" "sha256-6/XItNSFcgnd4QH87l04TKNm22wcgLLleJEqwB12dJ4=";
    });

    slock = slock.overrideAttrs (old: {
      src = fetchSucklessRepo "slock" "sha256-i13Aq3xQTML+UVWBTzIL2/sFbRn00GocMgH1sHKeN+Q=";
      buildInputs = old.buildInputs ++ (with xorg; [ libXinerama imlib2 libxft ]);
    });

    dwmblocks = dwmblocks.overrideAttrs (old: {
      src = fetchSucklessRepo "dwmblocks" "sha256-knhSzTcRadCC1ZFJBE/lnyuDO6L2iW3QSk3sIude4Ik=";
    });
  };
in
with pkgs; {
  system = [
    home-manager
    nix
    just
    htop
    sops
  ];

  shell = [
    zsh
    zsh-fast-syntax-highlighting
    zsh-system-clipboard
    tmux
    neovim
  ];

  cli = [
    pass
    ripgrep
    fzf
    wget
    curl
    tree
    fd
    zip
    unzip
    rsync
    bzip2
    killall
    zbar
    pstree
  ];

  network = [
    whois
    nmap
    wireguard-tools
    nextcloud-client
    tigervnc
  ];

  xorg = [
    dunst
    libnotify
    xclip
    feh
    redshift
    xidlehook
    xcompmgr
    xdotool
    xkblayout-state
    devour
    power-profiles-daemon
    pavucontrol
    pamixer

    #fonts
    noto-fonts-color-emoji
    font-awesome
    noto-fonts
  ] ++ (with suckless; [ dwm st dmenu slock dwmblocks ]);

  media = [
    mpv
    vlc
    spotify
    gimp
    sxiv
    inkscape
    imagemagick
    mediainfo
    transmission_4
  ];

  communication = [
    discord
    telegram-desktop
  ];

  fileManagement = [
    nautilus
    lf
    file
    poppler-utils
    gnome-epub-thumbnailer
    atool
    odt2txt
    djvulibre
    ueberzugpp
    zathura
    zathuraPkgs.zathura_ps
    zathuraPkgs.zathura_cb
    zathuraPkgs.zathura_djvu
    zathuraPkgs.zathura_pdf_mupdf
  ];

  office = [
    groff
    libreoffice-fresh
  ];

  email = [
    neomutt
    msmtp
    isync
    abook
    lynx
  ];

  development = [
    # tools
    gh
    tree-sitter
    python313Packages.tiktoken
    luajitPackages.jsregexp

    # Debuggers and tools
    gdb

    # Language servers
    nil
    marksman

    # Build tools
    cmake
    gnumake
    gcc

    # Languages and runtimes
    nodejs
    luarocks
    javaPackages.compiler.openjdk25
    lua5_1
    go
    ruby
    gem
    php
    julia-bin
    python3
    python313Packages.pip
    rustup
  ];
}
