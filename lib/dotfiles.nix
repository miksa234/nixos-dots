{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "bc693f185c1e6533bf11dc45f42e54d01b03d85e";
  };
}
