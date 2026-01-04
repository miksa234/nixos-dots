{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "fbaea6517ddf5c0ca2a3f3c41d0e61b5014adbfd";
  };
}
