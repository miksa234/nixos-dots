{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "bc6a6b7316a52034890fe0fa8985f2af82de3bfd";
  };
}
