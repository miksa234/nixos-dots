{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "9601661483c02e24aa2c578f31dfbb6abc0575a2";
  };
}
