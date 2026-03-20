{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "e748576e57aafbbde658d0309786f9ec23bafbd8";
  };
}
