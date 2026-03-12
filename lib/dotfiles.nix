{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "8aba7472abe5981d07a034e89f47538d7ef266ee";
  };
}
