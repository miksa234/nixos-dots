{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "1383a9986f7ffb72103f6959fc71db7852784e9e";
  };
}
