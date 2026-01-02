{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "160a7aca5464b9fac781ca2ea531e013283e1747";
  };
}
