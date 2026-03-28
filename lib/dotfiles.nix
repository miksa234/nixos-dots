{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "3a21b614e4ef8e9f0b3676b238f97854e4d9667d";
  };
}
