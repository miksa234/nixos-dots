{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "57c54e5f866a2e76faae1b1c640006965b55bbd9";
  };
}
