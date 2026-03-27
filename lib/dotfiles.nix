{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "bd02e6caeb77dd35d41672df3c4d8654ba2e6bb3";
  };
}
