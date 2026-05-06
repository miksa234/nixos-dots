{ ... }:
{
  dendritic.data.packageSetLinuxDesktop =
    {
      pkgs,
      lib,
      isDarwin ? false,
      suckless,
    }:
    with pkgs;
    {
      wayland = [
        swaybg
        swaylock
        xwayland-satellite
        fuzzel
        dmenu-wayland
        wl-clipboard
        grim
        mako
        swayidle
      ];

      network = [
        whois
        nmap
        wireguard-tools
        localsend
      ]
      ++ lib.optionals (!isDarwin) [
        uxplay
        localsend
        nextcloud-client
        tigervnc
      ];

      xorg = [
        xclip
        feh
        redshift
        xidlehook
        xcompmgr
        xdotool
        scrot
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
        power-profiles-daemon
        libnotify
        pavucontrol
        xkblayout-state
        cryptsetup
        rsync
        devour
        pamixer
        pulseaudio
        dunst
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

      office = [ groff ] ++ lib.optionals (!isDarwin) [
        texliveFull
        libreoffice-fresh
      ];

      email = [
        neomutt
        msmtp
        isync
        abook
        lynx
      ];
    };
}
