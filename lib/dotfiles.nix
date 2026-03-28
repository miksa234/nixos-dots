{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "211e377b24ab0cf7e6583678d358239cca20278a";
  };
}
