{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "8e9e195a6cf15039c5fcef5d8af7d3b94ed36d5c";
  };
}
