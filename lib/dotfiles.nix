{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "01e623309c73e3cbbe40577f81fe4186d74785c5";
  };
}
