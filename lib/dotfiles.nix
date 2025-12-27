{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "27ece9ddc49241b8e19a1f3b29dbf6ee64c4cfda";
  };
}
