{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "c7da35bd2000364b7b1ba53837f3d8d351934e73";
  };
}
