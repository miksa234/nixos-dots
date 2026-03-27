{ pkgs, isDarwin }:
let
  fetchSucklessRepo =
    repo: hash:
    pkgs.fetchgit {
      url = "git://popovic.xyz/${repo}.git";
      inherit hash;
    };

  suckless = with pkgs; {
    dwm = dwm.overrideAttrs (old: {
      src = fetchSucklessRepo "dwm" "sha256-Hj985b6fRcYZm49Sd6188OewhCrBk5N0uWwQF3q7TH0=";
      buildInputs = old.buildInputs ++ [ libxcb ];
    });

    st = st.overrideAttrs (old: {
      src = fetchSucklessRepo "st" "sha256-RYWB2LmEAafQUXhhtKi+7iJ6Ey5qLyTjjfLwOvNhu6U=";
    });

    dmenu = dmenu.overrideAttrs (old: {
      src = fetchSucklessRepo "dmenu" "sha256-YPtt7+wMickAYs271+lgKaUlWjxPwnsOJmaN/BS3ZzU=";
    });

    slock = slock.overrideAttrs (old: {
      src = fetchSucklessRepo "slock" "sha256-4cKVyYRqgv9YGYYHFzzkIoJhdMlzb5GC72RQsCSEbG0=";
      buildInputs =
        old.buildInputs
        ++ (with xorg; [
          libxinerama
          imlib2
          libxft
        ]);
    });

    dwmblocks = dwmblocks.overrideAttrs (old: {
      src = fetchSucklessRepo "dwmblocks" "sha256-08Afj+djz37J16Uz9jnl2iBwd/h4N11UU9nBvfkzVsU=";
    });
  };
in
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

  wayland = [
    swaybg
    swaylock
    xwayland-satellite
    fuzzel
    dmenu-wayland
    wl-clipboard
    grim
    mako
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
  ];

  network = [
    whois
    nmap
    wireguard-tools
  ]
  ++ lib.optionals (!isDarwin) [
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
    rsync
    devour
    power-profiles-daemon
    pavucontrol
    pamixer
    pulseaudio
    scrot
    cryptsetup
  ]
  ++ (with suckless; [
    dwm
    st
    dmenu
    slock
    dwmblocks
  ]);

  fonts = [
    noto-fonts-color-emoji
    font-awesome
    noto-fonts
  ];

  media = [
    mpv
    spotify
    inkscape
    imagemagick
    ghostscript
    pandoc
    mediainfo
    transmission_4
  ]
  ++ lib.optionals (!isDarwin) [
    vlc
    sxiv
    gimp
    chromium
  ];

  communication = [
    discord
    telegram-desktop
  ];

  fileManagement = [
    lf
    file
    ffmpegthumbnailer
    poppler-utils
    atool
    odt2txt
    djvulibre
    ueberzugpp
    zathura
    zathuraPkgs.zathura_ps
    zathuraPkgs.zathura_cb
    zathuraPkgs.zathura_djvu
    zathuraPkgs.zathura_pdf_mupdf
  ]
  ++ lib.optionals (!isDarwin) [
    nautilus
    gnome-epub-thumbnailer
  ];

  office = [
    groff
    texliveFull
  ]
  ++ lib.optionals (!isDarwin) [
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

    # Language servers
    nil
    marksman
    nodejs
    pnpm

    # Build tools
    cmake
    gnumake
    gcc

    # Languages and runtimes
    luarocks
    javaPackages.compiler.openjdk17
    lua5_1
    go
    ruby
    php
    julia-bin
    python3
    python313Packages.pip
    rustup
  ];
}
