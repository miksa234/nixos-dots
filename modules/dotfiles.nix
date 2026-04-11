{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "16f7908b64b131dca39309e7e82b3ca364dcd187";

  };
  nvim-config = builtins.fetchGit {
    url = "git://popovic.xyz/config.nvim.git";
    ref = "master";
    rev = "245555e22829a513703b9a0c6508a6cc35492e0a";

  };
}
