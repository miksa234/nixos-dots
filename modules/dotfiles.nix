{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "363cea507239c8ffcb81ef12f7e19060286ad475";

  };
  nvim-config = builtins.fetchGit {
    url = "git://popovic.xyz/nvim.config.git";
    ref = "master";
    rev = "a10499f8a7a4abe1c0d079b5b4bd4fe1470815d9";

  };
}
