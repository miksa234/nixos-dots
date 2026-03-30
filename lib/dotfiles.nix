{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "7fe8ce2cab3b3b9089bc4441ef9ea9ad9392ecd0";
  };
}
