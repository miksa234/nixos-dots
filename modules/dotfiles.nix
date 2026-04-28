{
  dotfiles = builtins.fetchGit {
    url = "git://popovic.xyz/dots.git";
    ref = "master";
    rev = "40ce8e88b8e50ba85dabc8a5088d5b3291c1117f";

  };
  nvim-config = builtins.fetchGit {
    url = "git://popovic.xyz/config.nvim.git";
    ref = "master";
    rev = "1f3cb04dbfd0597173cbed5f791185b40a6e99ea";

  };
}
