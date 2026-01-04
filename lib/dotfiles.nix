{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "87e0d4f41b10d31839a9edc96d8c16262d5ee686";
  };
}
