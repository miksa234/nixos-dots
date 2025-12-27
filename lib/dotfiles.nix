{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "1538636ece496b7cfa22ee530928dbb917088123";
  };
}
