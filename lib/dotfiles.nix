{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "496017e0fa9402ffcdbf44f8ed0398fed40a6fba";
  };
}
