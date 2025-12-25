{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "eff193581ef59565335e005f3555a254b7ca388a";
  };
}
