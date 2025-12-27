{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "dc91bcfaf82b648fc270d5b65424a6591a1396aa";
  };
}
