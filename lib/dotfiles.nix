{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "4598de6aabf7e1f0f8b2e5a52731524115674eec";
  };
}
