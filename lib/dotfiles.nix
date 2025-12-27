{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "09dce6d5f56e1ec1dfb52651928d918ea5afcbb4";
  };
}
