{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "253da659e61c816340357e02e20205fcc51bf0e0";
  };
}
